//
//  SNKGrid.swift
//  UISnakeGame
//
//  Created by William Rena on 7/24/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import Foundation
import WSRUtils

class SNKGrid {
    struct SNKGridLocation {
        var row: Int
        var column: Int
    }

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

    /**
     // two dimensional array
     //    [
     //        [CGPoint(0, 0), CGPoint(0, 1)],
     //        [CGPoint(1, 0), CGPoint(1, 0)]
     //    ]
     */
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

    func isValid(coordinate: CGPoint) -> Bool {
        for row in 0..<rows {
            if locations[row].contains(where: { $0.x == coordinate.x && $0.y == coordinate.y }) {
                return false
            }
        }
        return true
    }

    func isValid(row: Int, column: Int) -> Bool {
        return row < self.rows && column < self.columns
    }

    func randomLocation(excludedLocations: [CGPoint]? = nil) -> CGPoint {
        guard let excludedLocations
        else {
            let row = Int.random(in: 0..<rows)
            let column = Int.random(in: 0..<columns)
            //wsrLogger.info(message: "Random Location: [\(row)][\(column)]")

            return locations[Int(row)][Int(column)]
        }

        var row = 0
        var column = 0
        repeat {
            row = Int.random(in: 0..<rows)
            column = Int.random(in: 0..<columns)
        } while(excludedLocations.contains(
            where: { $0.x == locations[row][column].x && $0.y == locations[row][column].y })
        )
        return locations[Int(row)][Int(column)]
    }

    func getInfo() -> SNKGridInfo {
        return SNKGridInfo(rows: rows, columns: columns, area: area, tileSize: tileSize)
    }

    func getAvailableLocations(occupiedLocations: [CGPoint]) -> [CGPoint] {
        var availableLocations: [CGPoint] = []
        for row in 0..<rows {
            for col in 0..<columns {
                let location = locations[row][col]
                if !occupiedLocations.contains(where: { $0.x == location.x && $0.y == location.y }) {
                    availableLocations.append(location)
                }
            }
        }
        return availableLocations
    }

    // MARK: - Translations

    func coordinates(row: Int, column: Int) -> CGPoint {
        return locations[row][column]
    }
}
