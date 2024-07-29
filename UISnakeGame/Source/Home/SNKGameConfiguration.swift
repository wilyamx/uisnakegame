//
//  SNKGameConfiguration.swift
//  UISnakeGame
//
//  Created by William Rena on 7/29/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import Foundation

struct SNKStageData: Codable {
    let stage: Int
    let durationInSeconds: Int
    let startingSpeed: Int
    let minimumScore: Int
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
