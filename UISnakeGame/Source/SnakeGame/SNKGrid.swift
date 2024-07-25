//
//  SNKGrid.swift
//  UISnakeGame
//
//  Created by William Rena on 7/24/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import Foundation

class SNKGrid {
    struct SNKGridInfo {
        var rows: Int
        var columns: Int
        var area: CGSize
        var tileSize: CGFloat

        // computed values
        var rightMax: CGFloat { CGFloat(columns) * tileSize }
        var bottomMax: CGFloat { CGFloat(rows) * tileSize }
    }

    var rows: Int = 0
    var columns: Int = 0
    var tileSize: CGFloat = 0
    var locations: [[CGPoint]] = []
    var area: CGSize = .zero

    init(frame: CGRect, size: CGFloat) {
        area = frame.size
        tileSize = size
        rows = Int(frame.height / size)
        columns = Int(frame.width / size)

        wsrLogger.info(message: "rows: \(rows), columns: \(columns)")

        // initializing the 2d array
        locations = Array(
            repeating: Array(repeating: .zero, count: columns),
            count: rows
        )

        // assigning values to 2d array
        for row in 0..<rows {
            for col in 0..<columns {
                let position = CGPoint(x: CGFloat(col) * size, y: CGFloat(row) * size)
                //wsrLogger.info(message: "[\(row)][\(col)]: \(position)")
                locations[row][col] = position
            }
            //wsrLogger.info(message: "---")
        }
    }

    func randomLocation() -> CGPoint {
        let row = Int.random(in: 0..<rows)
        let column = Int.random(in: 0..<columns)
        wsrLogger.info(message: "Random Location: [\(row)][\(column)]")
        
        return locations[Int(row)][Int(column)]
    }

    func getInfo() -> SNKGridInfo {
        return SNKGridInfo(rows: rows, columns: columns, area: area, tileSize: tileSize)
    }
}
