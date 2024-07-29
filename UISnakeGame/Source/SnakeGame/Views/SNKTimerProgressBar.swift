//
//  SNKTimerProgressBar.swift
//  UISnakeGame
//
//  Created by William Rena on 7/29/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

class SNKTimerProgressBar: UIView {
    var bgColor: UIColor = UIColor(hexString: "#F5F5F5", alpha: 1.0)
    var barView: UIView

    private(set) var timer: Timer?
    private(set) var durationInSecond: Int = 0
    private(set) var maxDurationInSecond: Int = 0

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

    init(frame: CGRect, color: UIColor = .cyan) {
        self.barView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: frame.height))
        self.barView.backgroundColor = color
        super.init(frame: frame)

        addSubview(self.barView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func start(maxDuration: Int) {
        durationInSecond = 0
        maxDurationInSecond = maxDuration
        play()
    }

    func play() {
        pause()
        let timer = Timer.scheduledTimer(
            timeInterval: 1.0, target: self, selector: #selector(onTimerUpdate), userInfo: nil, repeats: true
        )
        self.timer = timer
    }

    func pause() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func onTimerUpdate() {
        durationInSecond += 1
        
        let percentage = Double(durationInSecond / maxDurationInSecond)
        //barView.frame.size.width = frame.width * percentage

        barView.frame.size.width += 10
        wsrLogger.info(message: "\(durationInSecond)/\(maxDurationInSecond)")
    }
}
