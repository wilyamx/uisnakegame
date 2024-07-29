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

struct SNKTileData: Decodable {
    let width: Int
    let height: Int
    let color: String
}

struct SNKGridData: Decodable {
    let spacing: Int
    let tile: SNKTileData
}

struct SNKSnakeData: Decodable {
    let defaultHeadColor: String
    let defaultBodyColor: String
    let defaultTailColor: String
}

struct SNKGameConfiguration: Decodable {
    let life: Int
    let grid: SNKGridData
    let snake: SNKSnakeData
    let stages: [SNKStageData]
}
