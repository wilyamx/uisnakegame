//
//  SNKConstants.swift
//  UISnakeGame
//
//  Created by William Rena on 7/25/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit
import WSRStorage

class SNKConstants: NSObject {
    typealias SNKLeaderboardItemInfo = SNKLeaderboardViewModel.ItemInfo
    typealias SNKUserGameProgressData = SNKSnakeGameViewModel.SNKUserGameProgressData

#if DEV
    // Default Values without the Configuration File
    static let TILE_SIZE = 15.0
    static let TILE_COLOR = UIColor(hexString: "#F7B15C")
    static let TILE_BG_COLOR = UIColor(hexString: "#2F5755")
    static let GRIDLINES_COLOR = UIColor.white
    static let FOOD_COLOR = UIColor(hexString: "#841EF5")
    static let OBSTACLE_COLOR = UIColor(hexString: "#000000")
    static let SNAKE_LENGTH = 4
    static let PROGRESS_BAR_COLOR = UIColor.orange
    static let GAME_DURATION_IN_SECONDS = 5
    static let SNAKE_HEAD_COLOR = UIColor(hexString: "#E5243F")
    static let SNAKE_BODY_COLOR = UIColor(hexString: "#F65C51")
    static let SNAKE_TAIL_COLOR = UIColor(hexString: "#2F5755")
    static let FOOD_SPAWN_COUNT = 2

    // Not Configurable
    static let DEFAULT_GAME_CONFIG_FILE = "default-game-config-dev.json"
    static let LEADERBOARD_COUNT = 20
    static let PROGRESS_BAR_HEIGHT = 3.0
    static let CASUAL_PLAY_MODE_OBSTACLE_COUNT = 10
    static let MINIMUM_SPEED = 0.18
    static let MINIMUM_FOOD_CREDIT = 2
#else
    // Default Values without the Configuration File
    static let TILE_SIZE = 15.0
    static let TILE_COLOR = UIColor(hexString: "#F7B15C")
    static let TILE_BG_COLOR = UIColor(hexString: "#2F5755")
    static let GRIDLINES_COLOR = UIColor.white
    static let FOOD_COLOR = UIColor(hexString: "#841EF5")
    static let OBSTACLE_COLOR = UIColor(hexString: "#000000")
    static let SNAKE_LENGTH = 8
    static let PROGRESS_BAR_COLOR = UIColor(hexString: "#E5243F")
    static let GAME_DURATION_IN_SECONDS = 20
    static let SNAKE_HEAD_COLOR = UIColor(hexString: "#E5243F")
    static let SNAKE_BODY_COLOR = UIColor(hexString: "#F65C51")
    static let SNAKE_TAIL_COLOR = UIColor(hexString: "#2F5755")
    static let FOOD_SPAWN_COUNT = 4

    // Not Configurable
    static let DEFAULT_GAME_CONFIG_FILE = "default-game-config.json"
    static let LEADERBOARD_COUNT = 20
    static let PROGRESS_BAR_HEIGHT = 3.0
    static let CASUAL_PLAY_MODE_OBSTACLE_COUNT = 10
    static let MINIMUM_SPEED = 0.18
    static let MINIMUM_FOOD_CREDIT = 2
#endif

    static var shared = SNKConstants()

    enum SNKKeys: String {
        case activeUser = "activeUser"
        case portraitOrientation = "portraitOrientation"
        case displayGrid = "displayGrid"
        case backgroundSound = "backgroundSound"
        case characterSound = "characterSound"
        case alertSound = "alertSound"
        case leaderboard = "leaderboard"
        case leaderboardCasual = "leaderboardCasual"
        case gameConfig = "gameConfig"
        case playMode = "playMode"
        case gameProgress = "gameProgress"
        case showTheMapGameplayObjective = "showTheMapGameplayObjective"
        case showTheCasualGameplayObjective = "showTheCasualGameplayObjective"
        case showInvisibleSnakeDetails = "showInvisibleSnakeDetails"
        case showHardHeadedSnakeDetails = "showHardHeadedSnakeDetails"
        case showFlexibleSnakeDetails = "showFlexibleSnakeDetails"
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

    @WSRUserDefaultsReadAndWrite(SNKKeys.backgroundSound.rawValue, default: false)
    var backgroundSound: Bool

    @WSRUserDefaultsReadAndWrite(SNKKeys.characterSound.rawValue, default: true)
    var characterSound: Bool

    @WSRUserDefaultsReadAndWrite(SNKKeys.alertSound.rawValue, default: true)
    var alertSound: Bool

    // Leaderboard

    @WSRUserDefaultCodable(SNKKeys.leaderboard.rawValue)
    var leaderboard: [SNKLeaderboardItemInfo]?

    @WSRUserDefaultCodable(SNKKeys.leaderboardCasual.rawValue)
    var leaderboardCasual: [SNKLeaderboardItemInfo]?

    // Game Configuration

    @WSRUserDefaultCodable(SNKKeys.gameConfig.rawValue)
    var gameConfig: SNKGameConfiguration?

    // true: map based
    // false: survival
    @WSRUserDefaultsReadAndWrite(SNKKeys.playMode.rawValue, default: true)
    var playMode: Bool

    // Game Progress

    @WSRUserDefaultsReadAndWrite(SNKKeys.showTheMapGameplayObjective.rawValue, default: false)
    var showTheMapGameplayObjective: Bool

    @WSRUserDefaultsReadAndWrite(SNKKeys.showTheCasualGameplayObjective.rawValue, default: false)
    var showTheCasualGameplayObjective: Bool

    @WSRUserDefaultCodable(SNKKeys.gameProgress.rawValue)
    var gameProgress: [SNKUserGameProgressData]?

    // eye
    @WSRUserDefaultsReadAndWrite(SNKKeys.showInvisibleSnakeDetails.rawValue, default: false)
    var showAboutInvisibleSnake: Bool

    // pill
    @WSRUserDefaultsReadAndWrite(SNKKeys.showHardHeadedSnakeDetails.rawValue, default: false)
    var showAboutHardHeadedSnake: Bool

    // wave
    @WSRUserDefaultsReadAndWrite(SNKKeys.showFlexibleSnakeDetails.rawValue, default: false)
    var showAboutFlexibleSnake: Bool

    // MARK: - Calculated Variables

    var leaderboardSorted: [SNKLeaderboardItemInfo]? {
        guard let leaderboard = leaderboard else { return nil }

        return leaderboard.sorted { lhs, rhs in
            return (lhs.score, rhs.name) > (rhs.score, lhs.name)
        }
    }

    var leaderboardCasualSorted: [SNKLeaderboardItemInfo]? {
        guard let leaderboard = leaderboardCasual else { return nil }

        return leaderboard.sorted { lhs, rhs in
            return (lhs.score, rhs.name) > (rhs.score, lhs.name)
        }
    }

    var hasActiveUser: Bool { SNKConstants.shared.activeUser.count >= 3 }

    // MARK: - Public Methods

    // MARK: - Private Methods

}
