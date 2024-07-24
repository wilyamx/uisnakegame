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
    enum State {
        case stopped
        case started
        case paused
    }

    //private(set) var grid: Grid?

    ///  all game objects will be added to this view
    var view: UIView = UIView()
    
    var frame: CGRect = .zero
    var tileSize: CGFloat = 0

    private(set) var snake: SNKSnake?
    private(set) var grid: SNKGrid?
    private(set) var gridView: SNKGridView?

    private(set) var state: State = .stopped
    private(set) var timer: Timer?
    private(set) var updateInterval: TimeInterval = 0.8 {
        didSet { start() }
    }

    init(frame: CGRect, tileSize: CGFloat) {
        self.frame = frame
        self.tileSize = tileSize
    }

    // MARK: - Game subviews

    func makeGridView(frame: CGRect, tileSize: CGFloat) {
        guard frame.size != .zero, tileSize != 0 else { fatalError("Check parameter values!")}

        let gridView = SNKGridView(frame: frame, size: tileSize)
        gridView.backgroundColor = .clear
        view.addSubview(gridView)

        self.gridView = gridView
    }

    func makeGrid(frame: CGRect, tileSize: CGFloat) {
        guard frame.size != .zero, tileSize != 0 else { fatalError("Check parameter values!")}

        self.grid = SNKGrid(frame: frame, size: tileSize)
    }
    
    func makeSnake() {

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

    func pause() {
        
    }

    // MARK: - Realtime Display

    @objc private func onEnterframe() {
        wsrLogger.info(message: "***")
    }
}
