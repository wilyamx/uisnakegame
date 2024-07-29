//
//  SNKConstants.swift
//  UISnakeGame
//
//  Created by William Rena on 7/25/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

class SNKConstants: NSObject {
    typealias SNKLeaderboardItemInfo = SNKLeaderboardViewModel.ItemInfo

    // Default Values without the Configuration File
    static let TILE_SIZE = 15.0 //15
    static let TILE_COLOR = UIColor.accentVariation4
    static let GRIDLINES_COLOR = UIColor.white
    static let FOOD_COLOR = UIColor.red
    static let OBSTACLE_COLOR = UIColor.black
    static let SNAKE_LENGTH = 4 //8
    static let PROGRESS_BAR_COLOR = UIColor.orange

    // No Configurable
    static let SPEED = 0.18 // 0
    static let PROGRESS_BAR_HEIGHT = 3.0
    static let DEFAULT_GAME_CONFIG_FILE = "default-game-config.json"

    static var shared = SNKConstants()

    enum SNKKeys: String {
        case activeUser = "activeUser"
        case portraitOrientation = "portraitOrientation"
        case displayGrid = "displayGrid"
        case backgroundSound = "backgroundSound"
        case characterSound = "characterSound"
        case alertSound = "alertSound"
        case leaderboard = "leaderboard"
        case currentStage = "currentStage"
        case gameConfig = "gameConfig"
        case playMode = "playMode"
    }

    // MARK: - Persistent Data

    // Gameplay

    @WSRUserDefaultsReadAndWrite(SNKKeys.activeUser.rawValue, default: "")
    var activeUser: String

    @WSRUserDefaultsReadAndWrite(SNKKeys.portraitOrientation.rawValue, default: true)
    var isPortraitOrientation: Bool

    @WSRUserDefaultsReadAndWrite(SNKKeys.displayGrid.rawValue, default: true)
    var displayGrid: Bool

    // Sounds

    @WSRUserDefaultsReadAndWrite(SNKKeys.backgroundSound.rawValue, default: true)
    var backgroundSound: Bool

    @WSRUserDefaultsReadAndWrite(SNKKeys.characterSound.rawValue, default: true)
    var characterSound: Bool

    @WSRUserDefaultsReadAndWrite(SNKKeys.alertSound.rawValue, default: true)
    var alertSound: Bool

    // Leaderboard

    @WSRUserDefaultCodable(key: SNKKeys.leaderboard.rawValue)
    var leaderboard: [SNKLeaderboardItemInfo]?

    // Game Configuration

    @WSRUserDefaultCodable(key: SNKKeys.gameConfig.rawValue)
    var gameConfig: SNKGameConfiguration?

    // true: map based
    // false: survival
    @WSRUserDefaultsReadAndWrite(SNKKeys.playMode.rawValue, default: true)
    var playMode: Bool

    // Game Progress

    @WSRUserDefaultsReadAndWrite(SNKKeys.currentStage.rawValue, default: 1)
    var currentStage: Int

    // MARK: - Calculated Variables

    var leaderboardSorted: [SNKLeaderboardItemInfo]? {
        guard let leaderboard = leaderboard else { return leaderboard }

        return leaderboard.sorted { lhs, rhs in
            return (lhs.score, rhs.name) > (rhs.score, lhs.name)
        }
    }

    var hasActiveUser: Bool { SNKConstants.shared.activeUser.count >= 3 }

    // MARK: - Public Methods

    // MARK: - Private Methods


}
