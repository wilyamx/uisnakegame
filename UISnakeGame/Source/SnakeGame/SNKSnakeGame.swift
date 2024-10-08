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
import WSRComponents
import WSRMedia
import WSRUtils

class SNKSnakeGame {
    typealias SNKDirection = SNKSnakeGameViewModel.SNKDirection
    typealias SNKGridLocation = SNKGrid.SNKGridLocation
    typealias SNKGridItem = SNKStageData.SNKGridItem
    typealias SNKImageTileType = SNKImageTileView.SNKImageTileType

    enum SNKState: Equatable {
        case stopped
        case started
        case stageComplete(Int)
        case gameOver(Int)
    }

    // all game objects will be added to this view
    var view: UIView = UIView()
    var frame: CGRect = .zero
    var tileSize: CGFloat = 0

    // actors
    private(set) var snake: SNKSnake?
    private(set) var grid: SNKGrid?
    private(set) var gridView: SNKGridView?

    // game management
    @Published var state: SNKState = .stopped
    var gameplay: SNKGameplayProtocol
    private(set) var timer: Timer?
    private(set) var updateInterval: TimeInterval = SNKConstants.MINIMUM_SPEED { didSet {
        start()
    } }
    private(set) var foodCredit: Int = 0

    // plotted actors in coordinates
    private(set) var foodLocations: [CGPoint] = []
    private(set) var obstacleLocations: [CGPoint] = []
    private(set) var waveLocations: [CGPoint] = []
    private(set) var pillLocations: [CGPoint] = []
    private(set) var eyeLocations: [CGPoint] = []

    // game info
    @Published var score: Int = 0
    @Published var stage: Int = 0
    @Published var snakeLength: Int = 0
    @Published var foodEatenCount: Int = 0
    @Published var skillAcquired: SNKImageTileType?
    lazy var cancellables = Set<AnyCancellable>()

    // theming
    private var tileColor: UIColor {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.TILE_COLOR }
        return UIColor(hexString: config.grid.color)
    }
    private var foodColor: UIColor {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.FOOD_COLOR }
        return UIColor(hexString: config.foodColor)
    }
    private var obstacleColor: UIColor {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.OBSTACLE_COLOR }
        return UIColor(hexString: config.obstacleColor)
    }
    private var defaultSnakeLength: Int {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.SNAKE_LENGTH }
        return config.snake.defaultLength
    }

    // sound effects
    private let collectSoundPlayer = WSRSoundPlayer(sound: .foodCollect, enabled: SNKConstants.shared.characterSound)
    private let gameOverSoundPlayer = WSRSoundPlayer(sound: .gameOver, enabled: SNKConstants.shared.alertSound)

    // MARK: - Constructor

    init(frame: CGRect, tileSize: CGFloat, gameplay: SNKGameplayProtocol) {
        self.frame = frame
        self.tileSize = tileSize
        self.gameplay = gameplay
        self.foodCredit = gameplay.minimumFoodCredit

        self.view.frame = frame
        self.view.backgroundColor = tileColor
        self.view.clipsToBounds = true
        wsrLogger.info(message: "frame: \(frame), tileSize: \(tileSize), foodCredit: \(gameplay.minimumFoodCredit)")
    }

    // MARK: - Actor Creator

    func makeGrid() {
        guard frame.size != .zero, tileSize != 0 else { fatalError("Check parameter values!") }
        self.grid = gameplay.grid(frame: frame, tileSize: tileSize)
    }

    func makeGridView() {
        guard frame.size != .zero, tileSize != 0 else { fatalError("Check parameter values!") }

        let gridView = gameplay.gridView(frame: frame, tileSize: tileSize)
        gridView.backgroundColor = .clear
        view.addSubview(gridView)

        self.gridView = gridView
    }

    func makeSnake(row: Int, column: Int) {
        guard let grid = grid, frame.size != .zero, tileSize != 0 else { return  }
        guard grid.isValid(row: row, column: column)
        else {
            fatalError("Grid [\(row)][\(column)] is invalid! Limit will be [\(grid.rows - 1)][\(grid.columns - 1)]")
        }

        if let previousSnake = snake {
            previousSnake.view.removeFromSuperview()
        }

        let location = grid.locations[row][column]
        let length = gameplay.snakeLength == 0 ? gameplay.defaultSnakeLength : gameplay.snakeLength
        let snake = SNKSnake(
            frame: frame, location: location, direction: .right,
            gridInfo: grid.getInfo(), length: length
        )

        view.addSubview(snake.view)

        self.snake = snake
        self.snakeLength = snakeLength
    }

    func placeObstacles() {
        guard grid != nil else { fatalError("Grid not available!") }

        // map game
        guard let gridLocations = gameplay.currentStageData()?.gridLocations(of: .obstacle)
        else {
            // casual game
            placeRandomObstacles(color: obstacleColor, count: SNKConstants.CASUAL_PLAY_MODE_OBSTACLE_COUNT)
            return
        }

        for location in gridLocations {
            placeObstacle(row: location.row, column: location.column, color: obstacleColor)
        }
    }

    func placeFoods() {
        guard grid != nil else { fatalError("Grid not available!") }

        // map game
        guard let gridLocations = gameplay.currentStageData()?.gridLocations(of: .food)
        else {
            // casual game
            //placeRandomObstacles(color: obstacleColor, count: SNKConstants.CASUAL_PLAY_MODE_OBSTACLE_COUNT)
            return
        }

        for location in gridLocations {
            placeFood(row: location.row, column: location.column, color: foodColor)
        }
    }

    func placeObstacle(row: Int, column: Int, color: UIColor) {
        guard let grid = grid else { fatalError("Grid not available!") }
        guard grid.isValid(row: row, column: column)
        else {
            fatalError("Grid [\(row)][\(column)] is invalid! Limit will be [\(grid.rows - 1)][\(grid.columns - 1)]")
        }

        let coordinates = grid.coordinates(row: row, column: column)
        let frame = CGRect(x: coordinates.x, y: coordinates.y, width: grid.tileSize, height: grid.tileSize)
        let item = SNKImageTileView(frame: frame, type: .obstacle)

        //wsrLogger.info(message: "\(coordinates)")
        obstacleLocations.append(coordinates)
        view.addSubview(item)
    }

    func placeFood(row: Int, column: Int, color: UIColor) {
        guard let grid = grid else { fatalError("Grid not available!") }
        guard grid.isValid(row: row, column: column)
        else {
            fatalError("Grid [\(row)][\(column)] is invalid! Limit will be [\(grid.rows - 1)][\(grid.columns - 1)]")
        }

        let coordinates = grid.coordinates(row: row, column: column)
        let frame = CGRect(x: coordinates.x, y: coordinates.y, width: grid.tileSize, height: grid.tileSize)
        let item = SNKTileView(frame: frame, color: color)

        //wsrLogger.info(message: "\(coordinates)")
        foodLocations.append(coordinates)
        view.addSubview(item)
    }

    func placeRandomFood() {
        guard let grid = grid else { fatalError("Grid not available!") }

        var location: CGPoint = grid.randomLocation(excludedLocations: obstacleLocations)
        if let snake = snake {
            repeat {
                location = grid.randomLocation(excludedLocations: obstacleLocations)
            } while(snake.intersect(with: location))
        }

        let frame = CGRect(x: location.x, y: location.y, width: grid.tileSize, height: grid.tileSize)
        let item = SNKImageTileView(frame: frame, type: .food)

        //wsrLogger.info(message: "\(location)")
        foodLocations.append(location)
        view.addSubview(item)
    }

    func placeRandomSkill() {
        guard let grid = grid else { fatalError("Grid not available!") }

        let number = Int.random(in: 0 ... 100)

        var type: SNKImageTileType = .wave

#if DEV
        if number % 2 == 0 { type = .pill }
        else if number % 3 == 1 { type = .wave }
        else { type = .eye }
#elseif TEST
        if number % 2 == 0 { type = .pill }
        else if number % 3 == 1 { type = .wave }
        else { type = .eye }
#else
        if number % 5 == 0 { type = .wave }
        else if number % 3 == 0 { type = .eye }
        else if number % 10 == 0 { type = .pill }
        else { return }
#endif

        let excludedLocations = obstacleLocations + foodLocations
        var location: CGPoint = grid.randomLocation(excludedLocations: excludedLocations)
        if let snake = snake {
            repeat {
                location = grid.randomLocation(excludedLocations: excludedLocations)
            } while(snake.intersect(with: location))
        }

        let frame = CGRect(x: location.x, y: location.y, width: grid.tileSize, height: grid.tileSize)
        let item = SNKImageTileView(frame: frame, type: type)

        //wsrLogger.info(message: "\(location)")
        if type == .wave { waveLocations.append(location) }
        else if type == .pill { pillLocations.append(location) }
        else if type == .eye { eyeLocations.append(location) }

        view.addSubview(item)
    }

    func placeRandomObstacles(color: UIColor, count: Int = 1, excludedLocations: [CGPoint]? = nil) {
        guard let grid = grid else { fatalError("Grid not available!") }

        var excludedLocations: [CGPoint] = []
        for _ in 0..<count {
            excludedLocations.append(grid.randomLocation(excludedLocations: excludedLocations))
        }

        for location in excludedLocations {
            let frame = CGRect(x: location.x, y: location.y, width: grid.tileSize, height: grid.tileSize)
            let item = SNKImageTileView(frame: frame, type: .obstacle)

            //wsrLogger.info(message: "\(location)")
            obstacleLocations.append(location)
            view.addSubview(item)
        }
    }

    // MARK: - Directions

    func changeSnakeDirection(to direction: SNKDirection) {
        snake?.changeDirection(to: direction)
    }

    // MARK: - Game Control

    func start() {
        guard grid != nil else { fatalError("Missing grid!") }

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
        gameOverSoundPlayer.play()
        state = .gameOver(score)
    }

    func updateGameSpeed() {
        guard let snake = snake else { return }

        let variableSpeed = speedForSnakeLength(snake.length)
        let newUpdateInterval = gameplay.minimumSpeed - variableSpeed

        guard updateInterval != newUpdateInterval else { return }

        updateInterval = newUpdateInterval
        wsrLogger.info(message: "[Gameplay] Minimum Speed: \(gameplay.minimumSpeed), Variable Snake Speed: \(variableSpeed), Update Speed: \(String(format: "%.2f", updateInterval))")
    }

    func updateFoodCredit() {
        guard snake != nil else { return }

        let variableFoodCredit = (snakeLength - gameplay.defaultSnakeLength) * 2
        let newFoodCredit = gameplay.minimumFoodCredit + variableFoodCredit

        guard foodCredit != newFoodCredit else { return }

        foodCredit = newFoodCredit
        wsrLogger.info(message: "[Gameplay] Minimum Food Credit: \(gameplay.minimumFoodCredit), Variable Food Credit: \(variableFoodCredit), Food Credit: \(foodCredit)")
    }

    // MARK: - Realtime Display

    @objc private func onEnterframe() {
        guard let snake else { return }
        //wsrLogger.info(message: "speed: \(updateInterval)")

        snake.move()

        if snakeIntersectWithItself()  {
            snake.moveToPreviousLocation()
            gameOver()
        }
        else {
            if let location = snakeIntersectWithObstacles() {
                if snake.hardHead {
                    eatObstacleItem(from: location)
                }
                else if snake.invisibility {
                    // ignore
                }
                else {
                    snake.moveToPreviousLocation()
                    gameOver()
                }
            }
            else if let location = snakeIntersectToFoodItems() {
                eatFoodItem(from: location)
                snakeLength = snake.grow()
                placeRandomFood()
            }
            else if let location = snakeIntersectWithPill() {
                skillAcquired = .pill
                eatPillItem(from: location)
                snake.normalBodyParts()
                snake.hardHead = true
            }
            else if let location = snakeIntersectWithWave() {
                skillAcquired = .wave
                eatWaveItem(from: location)
                snake.normalBodyParts()
                snake.flexibility = true
            }
            else if let location = snakeIntersectWithEye() {
                skillAcquired = .eye
                eatEyeItem(from: location)
                snake.normalBodyParts()
                snake.invisibility = true
            }
        }

        updateGameSpeed()
        updateFoodCredit()
    }

    // MARK: - Collision Detection

    private func snakeIntersectWithItself() -> Bool {
        guard let snake, !snake.flexibility else { return false }
        return snake.intersectWithItself()
    }

    private func snakeIntersectWithObstacles() -> CGPoint? {
        guard let snake, !obstacleLocations.isEmpty else { return nil }
        return snake.intersect(with: obstacleLocations)
    }

    private func snakeIntersectToFoodItems() -> CGPoint? {
        guard let snake, !foodLocations.isEmpty else { return nil }
        return snake.intersect(with: foodLocations)
    }

    private func snakeIntersectWithPill() -> CGPoint? {
        guard let snake, !pillLocations.isEmpty else { return nil }
        return snake.intersect(with: pillLocations)
    }

    private func snakeIntersectWithWave() -> CGPoint? {
        guard let snake, !waveLocations.isEmpty else { return nil }
        return snake.intersect(with: waveLocations)
    }

    private func snakeIntersectWithEye() -> CGPoint? {
        guard let snake, !eyeLocations.isEmpty else { return nil }
        return snake.intersect(with: eyeLocations)
    }

    // MARK: - Eating

    private func eatObstacleItem(from location: CGPoint) {
        for item in view.subviews {
            if item.frame.origin.x == location.x && item.frame.origin.y == location.y {
                obstacleLocations.removeAll(where: { $0.x == location.x && $0.y == location.y})
                item.removeFromSuperview()

                collectSoundPlayer.play()
                wsrLogger.info(message: "\(location)")
                break
            }
        }
    }

    private func eatFoodItem(from location: CGPoint) {
        for item in view.subviews {
            if item.frame.origin.x == location.x && item.frame.origin.y == location.y {
                foodLocations.removeAll(where: { $0.x == location.x && $0.y == location.y})
                item.removeFromSuperview()

                score += gameplay.minimumFoodCredit
                foodEatenCount += 1

                collectSoundPlayer.play()
                wsrLogger.info(message: "\(location)")
                break
            }
        }
    }

    private func eatPillItem(from location: CGPoint) {
        for item in view.subviews {
            if item.frame.origin.x == location.x && item.frame.origin.y == location.y {
                pillLocations.removeAll(where: { $0.x == location.x && $0.y == location.y})
                item.removeFromSuperview()

                collectSoundPlayer.play()
                wsrLogger.info(message: "\(location)")
                break
            }
        }
    }

    private func eatWaveItem(from location: CGPoint) {
        for item in view.subviews {
            if item.frame.origin.x == location.x && item.frame.origin.y == location.y {
                waveLocations.removeAll(where: { $0.x == location.x && $0.y == location.y})
                item.removeFromSuperview()

                collectSoundPlayer.play()
                wsrLogger.info(message: "\(location)")
                break
            }
        }
    }

    private func eatEyeItem(from location: CGPoint) {
        for item in view.subviews {
            if item.frame.origin.x == location.x && item.frame.origin.y == location.y {
                eyeLocations.removeAll(where: { $0.x == location.x && $0.y == location.y})
                item.removeFromSuperview()

                collectSoundPlayer.play()
                wsrLogger.info(message: "\(location)")
                break
            }
        }
    }

    private func foodCreditVariation() -> Int {
        return snakeLength
    }

    // MARK: - Speed Variation

    private func speedForSnakeLength(_ snakeLength: Int) -> TimeInterval {
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

        return Double(speedVariation)
    }
}
