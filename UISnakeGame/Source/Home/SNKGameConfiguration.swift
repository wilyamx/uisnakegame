//
//  SNKGameConfiguration.swift
//  UISnakeGame
//
//  Created by William Rena on 7/29/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import Foundation

struct SNKStageData: Codable {
    typealias SNKGridLocation = SNKGrid.SNKGridLocation

    let stage: Int
    let durationInSeconds: Int
    let startingSpeed: Int
    let minimumScore: Int
    let mapping: [[Int]]

    func obstacleGridLocations() -> [SNKGridLocation] {
        var locations: [SNKGridLocation] = []
        for (rowIndex, row) in mapping.enumerated() {
            for (columnIndex, element) in row.enumerated() {
                if element == 1 {
                    locations.append(SNKGridLocation(row: rowIndex, column: columnIndex))
                }
            }
        }
        return locations
    }

    func mapSize() -> (rows: Int, columns: Int) {
        return (rows: mapping.count, columns: mapping[0].count)
    }
}

struct SNKGridData: Codable {
    let color: String
    let lineColor: String
    let size: Int
}

struct SNKSnakeData: Codable {
    let defaultLength: Int
    let defaultHeadColor: String
    let defaultBodyColor: String
    let defaultTailColor: String
}

struct SNKGameConfiguration: Codable {
    let life: Int
    let grid: SNKGridData
    let snake: SNKSnakeData
    let foodColor: String
    let obstacleColor: String
    let progressBarColor: String
    let stages: [SNKStageData]
}
