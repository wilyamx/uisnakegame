//
//  SNKGridView.swift
//  UISnakeGame
//
//  Created by William Rena on 7/24/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

class SNKGridView: UIView {

    var columns: Int = 0
    var rows: Int = 0
    var origin: CGPoint = .zero
    var size: CGFloat = 0

    let gridColor: UIColor = SNKConstants.GRIDLINES_COLOR

    override func draw(_ rect: CGRect) {
        drawGrid()
    }

    private func drawGrid() {
        let gridPath = UIBezierPath()
        gridPath.lineWidth = 0.5

        for i in 0...rows {
            gridPath.move(to: CGPoint(x: origin.x, y: origin.y + CGFloat(i) * size))
            gridPath.addLine(to: CGPoint(x: origin.x + CGFloat(columns) * size, y: origin.y + CGFloat(i) * size))
        }

        for i in 0...columns {
            gridPath.move(to: CGPoint(x: origin.x + CGFloat(i) * size, y: origin.y))
            gridPath.addLine(to: CGPoint(x: origin.x + CGFloat(i) * size, y: origin.y + CGFloat(rows) * size))
        }

        gridColor.setStroke()
        gridPath.stroke()
    }

    init(frame: CGRect, size: CGFloat = 30, origin: CGPoint = .zero) {
        super.init(frame: frame)
        self.size = size
        self.origin = origin
        self.rows = Int(frame.height / size)
        self.columns = Int(frame.width / size)

        wsrLogger.info(message: "rows: \(rows), columns: \(columns)")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
