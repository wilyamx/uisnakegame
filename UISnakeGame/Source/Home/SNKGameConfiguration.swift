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

    enum SNKGridItem: Int {
        case space = 0
        case obstacle = 1
        case food = 2
    }

    let stage: Int
    let stageName: String
    let durationInSeconds: Int
    let foodSpawnCount: Int
    let minimumSpeed: CGFloat
    let minimumFoodCredit: Int
    let mapping: [[Int]]

    func gridLocations(of item: SNKGridItem) -> [SNKGridLocation] {
        var locations: [SNKGridLocation] = []
        for (rowIndex, row) in mapping.enumerated() {
            for (columnIndex, element) in row.enumerated() {
                if element == item.rawValue {
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
    let backgroundColor: String
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
    let durationInSeconds: Int
    let foodSpawnCount: Int
    let minimumSpeed: CGFloat
    let minimumFoodCredit: Int
    let stages: [SNKStageData]
}
