//
//  SNKGame.swift
//  UISnakeGame
//
//  Created by William Rena on 7/24/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit
import SuperEasyLayout

class SNKSnakeGame {
    typealias SNKDirection = SNKSnakeGameViewModel.SNKDirection

    enum SNKState {
        case stopped
        case started
        case paused
    }

    ///  all game objects will be added to this view
    var view: UIView = UIView()
    
    var frame: CGRect = .zero
    var tileSize: CGFloat = 0

    private(set) var snake: SNKSnake?
    private(set) var grid: SNKGrid?
    private(set) var gridView: SNKGridView?

    private(set) var state: SNKState = .stopped
    private(set) var timer: Timer?
    private(set) var updateInterval: TimeInterval = 0.3 {
        didSet { start() }
    }

    init(frame: CGRect, tileSize: CGFloat) {
        self.frame = frame
        self.tileSize = tileSize
        wsrLogger.info(message: "frame: \(frame), tileSize: \(tileSize)")
    }

    // MARK: - Game subviews

    func makeGrid() {
        guard frame.size != .zero, tileSize != 0 else { fatalError("Check parameter values!") }

        self.grid = SNKGrid(frame: frame, size: tileSize)
    }

    func makeGridView() {
        guard frame.size != .zero, tileSize != 0 else { fatalError("Check parameter values!") }

        let gridView = SNKGridView(frame: frame, size: tileSize)
        gridView.backgroundColor = .clear
        view.addSubview(gridView)

        self.gridView = gridView
    }

    func makeSnake() {
        guard let grid = grid else { fatalError("Grid not available!") }
        guard frame.size != .zero, tileSize != 0 else { fatalError("Check parameter values!") }

        if let previousSnake = snake {
            previousSnake.view.removeFromSuperview()
        }

        let snake = SNKSnake(frame: frame, size: tileSize, location: grid.locations[0][0], gridInfo: grid.getInfo())

        view.addSubview(snake.view)

        self.snake = snake
    }

    // MARK: - Others

    func changeSnakeDirection(to direction: SNKDirection) {
        snake?.changeDirection(to: direction)
    }
    
    func placeRandomFood(color: UIColor) {
        guard let grid = grid else { fatalError("Grid not available!") }
        
        let location = grid.randomLocation()
        let bodyFrame = CGRect(x: location.x, y: location.y, width: grid.tileSize, height: grid.tileSize)
        let food = SNKTileView(frame: bodyFrame, color: .orange)

        view.addSubview(food)
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
    
    // MARK: - Realtime Display

    @objc private func onEnterframe() {
        //wsrLogger.info(message: "***")
        snake?.move()
    }
}
