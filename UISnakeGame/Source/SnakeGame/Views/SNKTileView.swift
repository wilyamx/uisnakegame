//
//  SNKTileView.swift
//  UISnakeGame
//
//  Created by William Rena on 7/24/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

class SNKTileView: UIView {
    var fillColor: UIColor = .purple

    override func draw(_ rect: CGRect) {
        drawTile()
    }

    private func drawTile() {
        let gridPath = UIBezierPath()
        gridPath.lineWidth = 5

        gridPath.move(to: CGPoint(x: 0, y: 0))
        gridPath.addLine(to: CGPoint(x: frame.width, y: 0))
        gridPath.addLine(to: CGPoint(x: frame.width, y: frame.height))
        gridPath.addLine(to: CGPoint(x: 0, y: frame.height))
        gridPath.addLine(to: CGPoint(x: 0, y: 0))

        fillColor.setFill()
        gridPath.fill()
    }

    init(frame: CGRect, color: UIColor = .purple) {
        super.init(frame: frame)
        self.fillColor = color
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func drawBorder() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
    }
}
