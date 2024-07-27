//
//  SNKConstants.swift
//  UISnakeGame
//
//  Created by William Rena on 7/25/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

class SNKConstants: NSObject {
    static var TILE_SIZE = 15.0 //15
    static var SPEED = 0.15
    static var GRIDLINES_COLOR = UIColor.white
    static var TILE_COLOR = UIColor.accentVariation4
    static var FOOD_COLOR = UIColor.red
    static var OBSTACLE_COLOR = UIColor.black
    static var SNAKE_LENGTH = 20 //8

    static var shared = SNKConstants()

    enum SNKKeys: String {
        case activeUser = "activeUser"
        case portraitOrientation = "portraitOrientation"
        case displayGrid = "displayGrid"
        case backgroundSound = "backgroundSound"
        case characterSound = "characterSound"
        case alertSound = "alertSound"
        case leaderboard = "leaderboard"
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

    // MARK: - Public Methods

    func hasActiveUser() -> Bool {
        return SNKConstants.shared.activeUser.count >= 3
    }

    // MARK: Private Methods


}
