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

    private lazy var gridView: SNKGridView = {
        let view = SNKGridView(frame: frame)
        view.backgroundColor = .clear
        return view
    }()

    //let blockSize = Size(width: 25, height: 25)

    //private(set) var grid: Grid?

    ///  all game objects will be added to this view
    var view: UIView = UIView()
    
    var frame: CGRect = .zero

    private(set) var snake: SNKSnake?
    
    private(set) var state: State = .stopped
    private(set) var timer: Timer?
    private(set) var updateInterval: TimeInterval = 0.8 {
        didSet { start() }
    }

    init(frame: CGRect) {
        self.frame = frame
        configureViewSizeContraints()
    }

    private func configureViewSizeContraints() {
        view.addSubview(gridView)
    }

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

    @objc private func onEnterframe() {
        wsrLogger.info(message: "***")
    }
}
