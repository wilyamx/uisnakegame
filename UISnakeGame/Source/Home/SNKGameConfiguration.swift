//
//  SNKGameConfiguration.swift
//  UISnakeGame
//
//  Created by William Rena on 7/29/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import Foundation

struct SNKStageData: Decodable {
    let stage: Int
    let durationInSeconds: Int
    let startingSpeed: Int
    let minimumScore: Int
}

struct SNKGridData: Decodable {
    let color: String
    let size: Int
}

struct SNKSnakeData: Decodable {
    let defaultLength: Int
    let defaultHeadColor: String
    let defaultBodyColor: String
    let defaultTailColor: String
}

struct SNKGameConfiguration: Decodable {
    let life: Int
    let grid: SNKGridData
    let snake: SNKSnakeData
    let foodColor: String
    let obstacleColor: String
    let stages: [SNKStageData]
}
