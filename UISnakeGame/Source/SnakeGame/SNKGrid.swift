//
//  SNKGrid.swift
//  UISnakeGame
//
//  Created by William Rena on 7/24/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import Foundation

class SNKGrid {

    struct SNKGridLocation {
        var row: Int
        var column: Int
        var position: CGPoint
    }

    var locations: [SNKGridLocation] = []

    init(frame: CGRect, size: CGFloat) {
        let rows = Int(frame.height / size)
        let columns = Int(frame.width / size)
        wsrLogger.info(message: "rows: \(rows), columns: \(columns)")

        for row in 0..<rows {
            for col in 0..<columns {
                let position = CGPoint(x: 0, y: 0)
                locations.append(SNKGridLocation(row: row, column: col, position: position))
            }
        }
    }
}
