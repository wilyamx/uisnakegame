//
//  SNKGame.swift
//  UISnakeGame
//
//  Created by William Rena on 7/24/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit
import SuperEasyLayout
import Combine

class SNKSnakeGame {
    typealias SNKDirection = SNKSnakeGameViewModel.SNKDirection

    enum SNKState {
        case stopped
        case started
    }

    enum SNKAlertState {
        case newLevel
        case levelComplete
        case gameOver(Int)
    }

    ///  all game objects will be added to this view
    var view: UIView = UIView()
    
    var frame: CGRect = .zero
    var tileSize: CGFloat = 0

    // actors
    private(set) var snake: SNKSnake?
    private(set) var grid: SNKGrid?
    private(set) var gridView: SNKGridView?

    // game management
    private(set) var state: SNKState = .stopped
    private(set) var timer: Timer?
    private(set) var updateInterval: TimeInterval = SNKConstants.SPEED {
        didSet { start() }
    }

    // plotted actors
    private(set) var foodLocations: [CGPoint] = []
    private(set) var obstacleLocations: [CGPoint] = []

    // game info
    @Published var score: Int = 0
    @Published var level: Int = 0
    @Published var snakeLength: Int = 0
    @Published var alertState: SNKAlertState?
    lazy var cancellables = Set<AnyCancellable>()

    init(frame: CGRect, tileSize: CGFloat) {
        self.frame = frame
        self.tileSize = tileSize
        wsrLogger.info(message: "frame: \(frame), tileSize: \(tileSize)")
    }

    // MARK: - Actor Creator

    func makeGrid() {
        guard frame.size != .zero, tileSize != 0 else { fatalError("Check parameter values!") }

        self.grid = SNKGrid(frame: frame, size: tileSize)
    }

    func makeGridView() {
        guard frame.size != .zero, tileSize != 0 else { fatalError("Check parameter values!") }

        let gridView = SNKGridView(frame: frame, size: tileSize)
        gridView.backgroundColor = .clear
        view.addSubview(gridView)

//        gridView.translatesAutoresizingMaskIntoConstraints = false
//        gridView.left == view.left
//        gridView.right == view.right
//        gridView.top == view.top
//        gridView.bottom == view.bottom

        self.gridView = gridView
    }

    func makeSnake() {
        guard let grid = grid, frame.size != .zero, tileSize != 0 else { return  }

        if let previousSnake = snake {
            previousSnake.view.removeFromSuperview()
        }

        let location = grid.locations[1][1]
        let snakeLength = SNKConstants.SNAKE_LENGTH
        let snake = SNKSnake(frame: frame, size: tileSize, location: location,
                             direction: .right, gridInfo: grid.getInfo(), length: snakeLength)

        view.addSubview(snake.view)

        self.snake = snake
        self.snakeLength = snakeLength
    }

    func placeRandomFood(color: UIColor) {
        guard let grid = grid else { fatalError("Grid not available!") }

        var location: CGPoint = grid.randomLocation(excludedLocations: obstacleLocations)
        if let snake = snake {
            repeat {
                location = grid.randomLocation(excludedLocations: obstacleLocations)
            } while(snake.intersect(with: location))
        }

        let foodFrame = CGRect(x: location.x, y: location.y, width: grid.tileSize, height: grid.tileSize)
        let food = SNKTileView(frame: foodFrame, color: .orange)

        //wsrLogger.info(message: "\(location)")
        foodLocations.append(location)
        view.addSubview(food)
    }

    func placeRandomObstacle(color: UIColor = SNKConstants.OBSTACLE_COLOR, excludedLocations: [CGPoint]? = nil) {
        guard let grid = grid else { fatalError("Grid not available!") }
        guard let snake = snake else { return }

        var location: CGPoint
        repeat {
            location = grid.randomLocation(excludedLocations: excludedLocations)
        } while(snake.intersect(with: location))

        let foodFrame = CGRect(x: location.x, y: location.y, width: grid.tileSize, height: grid.tileSize)
        let food = SNKTileView(frame: foodFrame, color: .orange)

        wsrLogger.info(message: "\(location)")
        foodLocations.append(location)
        view.addSubview(food)
    }

    func placeObstacle(row: Int, column: Int, color: UIColor = SNKConstants.OBSTACLE_COLOR) {
        guard let grid = grid else { fatalError("Grid not available!") }
        guard grid.isValid(row: row, column: column)
        else {
            fatalError("Grid [\(row)][\(column)] is invalid! Limit will be [\(grid.rows - 1)][\(grid.columns - 1)]")
        }

        let coordinates = grid.coordinates(row: row, column: column)
        let frame = CGRect(x: coordinates.x, y: coordinates.y, width: grid.tileSize, height: grid.tileSize)
        let item = SNKTileView(frame: frame, color: color)

        //wsrLogger.info(message: "\(coordinates)")
        obstacleLocations.append(coordinates)
        view.addSubview(item)
    }

    // MARK: - Directions

    func changeSnakeDirection(to direction: SNKDirection) {
        snake?.changeDirection(to: direction)
    }

    // MARK: - Game Control

    func start() {
        stop()

        let timer = Timer(timeInterval: updateInterval,
                          target: self, selector: #selector(onEnterframe),
                          userInfo: nil, repeats: true)
        self.timer = timer
        RunLoop.main.add(timer, forMode: .default)
        state = .started
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        state = .stopped
    }

    func pause() -> SNKState {
        state == .stopped ? start() : stop()
        return state
    }

    func restart() {
        stop()

        view.removeFromSuperview()
        snake = nil
        grid = nil
        gridView = nil
    }

    func gameOver() {
        stop()
        alertState = .gameOver(score)
    }

    func updateGameSpeed() {
        guard let snake = snake else { return }

        let newUpdateInterval = speedForSnakeLength(snake.length, baseSpeed: SNKConstants.SPEED)
        guard updateInterval != newUpdateInterval else { return }

        wsrLogger.info(message: "new speed: \(updateInterval)")
        updateInterval = newUpdateInterval
    }

    // MARK: - Realtime Display

    @objc private func onEnterframe() {
        guard let snake else { return }
        //wsrLogger.info(message: "speed: \(updateInterval)")

        snake.move()

        if snakeIntersectWithItself() || snakeIntersectWithObstacles() {
            gameOver()
        }
        else {
            if let foodItemLocation = snakeIntersectToFoodItems() {
                eatFoodItem(from: foodItemLocation)
                snakeLength = snake.grow()
                placeRandomFood(color: SNKConstants.FOOD_COLOR)
            }
        }

        updateGameSpeed()
    }

    // MARK: Collision Detection

    private func snakeIntersectToFoodItems() -> CGPoint? {
        guard let snake, !foodLocations.isEmpty else { return nil }
        return snake.intersect(with: foodLocations)
    }

    private func snakeIntersectWithItself() -> Bool {
        guard let snake else { return false }
        return snake.intersectWithItself()
    }

    private func snakeIntersectWithObstacles() -> Bool {
        guard let snake else { return false }
        return snake.intersect(with: obstacleLocations) != nil
    }

    // MARK: - Food

    private func eatFoodItem(from location: CGPoint) {
        for item in view.subviews {
            if item.frame.origin.x == location.x && item.frame.origin.y == location.y {
                foodLocations.removeAll(where: { $0.x == location.x && $0.y == location.y})
                item.removeFromSuperview()

                score += 1
                //wsrLogger.info(message: "\(location)")
                break
            }
        }
    }

    // MARK: Speed Variation

    private func speedForSnakeLength(_ snakeLength: Int, baseSpeed: TimeInterval = 0) -> TimeInterval {
        var speedVariation: Double = 0

        if snakeLength <= 4 {
            speedVariation = 0.01
        } else if snakeLength <= 6 {
            speedVariation = 0.015
        } else if snakeLength <= 8 {
            speedVariation = 0.02
        } else if snakeLength <= 11 {
            speedVariation = 0.03
        } else if snakeLength <= 15 {
            speedVariation = 0.04
        } else if snakeLength <= 19 {
            speedVariation = 0.05
        } else if snakeLength <= 22 {
            speedVariation = 0.06
        } else if snakeLength <= 26 {
            speedVariation = 0.07
        } else {
            speedVariation = 0.3
        }

        return baseSpeed - Double(speedVariation)
    }
}
