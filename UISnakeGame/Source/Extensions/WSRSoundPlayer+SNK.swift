//
//  WSRSoundPlayer+SNK.swift
//  UISnakeGame
//
//  Created by William Rena on 7/27/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import Foundation

typealias WSRSound = WSRSoundPlayer.WSRSound

// MARK: - Available Sound Effects

extension WSRSound {
    static let move = WSRSound(name: "move", withExtension: "mp3")
    static let foodCollect = WSRSound(name: "collectCoin", withExtension: "wav")
    static let gameOver = WSRSound(name: "game-over-arcade", withExtension: "mp3")
    static let hiscore = WSRSound(name: "audienceApplauding", withExtension: "mp3")
    static let stageComplete = WSRSound(name: "levelUp", withExtension: "mp3")
    static let stageWelcome = WSRSound(name: "advertising-logo", withExtension: "mp3")
    static let background = WSRSound(name: "typical-trap-loop", withExtension: "mp3")
}
