//
//  SNKTimerProgressBar.swift
//  UISnakeGame
//
//  Created by William Rena on 7/29/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

class SNKTimerProgressBar: UIView {
    var bgColor: UIColor = .lightGray
    var barColor: UIColor = .orange

    var barView: UIView

    private(set) var timer: Timer?
    private(set) var durationInSecond: Int = 0

    override func draw(_ rect: CGRect) {
        drawProgressBar()
    }

    private func drawProgressBar() {
        let bgPath = UIBezierPath()
        bgPath.lineWidth = 0
        bgPath.move(to: CGPoint(x: 0, y: 0))
        bgPath.addLine(to: CGPoint(x: frame.width, y: 0))
        bgPath.addLine(to: CGPoint(x: frame.width, y: frame.height))
        bgPath.addLine(to: CGPoint(x: 0, y: frame.height))
        bgPath.addLine(to: CGPoint(x: 0, y: 0))
        bgColor.setFill()
        bgPath.fill()
    }

    init(frame: CGRect, color: UIColor = .purple) {
        self.barView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 2))
        self.barView.backgroundColor = barColor
        super.init(frame: frame)

        addSubview(self.barView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func start() {
        stop()

        let timer = Timer(timeInterval: 1.0,
                          target: self, selector: #selector(onTimerUpdate),
                          userInfo: nil, repeats: true)
        self.timer = timer
    }

    func stop() {
        durationInSecond = 0

        timer?.invalidate()
        timer = nil
    }

    @objc private func onTimerUpdate() {
        durationInSecond += 1
        wsrLogger.info(message: "\(durationInSecond)")
    }
}
