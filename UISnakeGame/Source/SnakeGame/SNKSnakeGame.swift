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

    // score + level + alerts
    @Published var score: Int = 0
    @Published var level: Int = 0
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
        let snake = SNKSnake(frame: frame, size: tileSize, location: location,
                             direction: .right, gridInfo: grid.getInfo(), length: 8)

        view.addSubview(snake.view)

        self.snake = snake
    }

    func placeRandomFood(color: UIColor) {
        guard let grid = grid else { fatalError("Grid not available!") }
        guard let snake = snake else { return }

        var location: CGPoint
        repeat {
            location = grid.randomLocation()
        } while(snake.intersect(with: location))

        let foodFrame = CGRect(x: location.x, y: location.y, width: grid.tileSize, height: grid.tileSize)
        let food = SNKTileView(frame: foodFrame, color: .orange)

        wsrLogger.info(message: "\(location)")
        foodLocations.append(location)
        view.addSubview(food)
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

    // MARK: - Realtime Display

    @objc private func onEnterframe() {
        guard let snake else { return }

        snake.move()

        if snakeIntersectWithItself() {
            gameOver()
        }
        else {
            if let foodItemLocation = snakeIntersectToFoodItems() {
                eatFoodItem(from: foodItemLocation)
                snake.grow()
                placeRandomFood(color: SNKConstants.FOOD_COLOR)
            }
        }
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

    // MARK: - Food

    private func eatFoodItem(from location: CGPoint) {
        for item in view.subviews {
            if item.frame.origin.x == location.x && item.frame.origin.y == location.y {
                foodLocations.removeAll(where: { $0.x == location.x && $0.y == location.y})
                item.removeFromSuperview()

                score += 1
                wsrLogger.info(message: "\(location)")
                break
            }
        }
    }
}
