//
//  SNKGameError.swift
//  UISnakeGame
//
//  Created by William Rena on 7/28/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit
import WSRCommon
import WSRMedia

enum SNKGameError: Error, LocalizedError, WSRActionableError {
    typealias CustomErrorActionType = ActionType

    case configurationFileInvalid(String)
    case minUserCharacterCount(String)
    case invalidUser(String)

    var title: String? {
        switch self {
        case .configurationFileInvalid: "Configuration File Invalid"
        case .minUserCharacterCount, .invalidUser: "Invalid User"
        }
    }

    var errorDescription: String? {
        switch self {
        case .configurationFileInvalid(let filename): "Invalid configuration file \(filename)"
        case .minUserCharacterCount: "User should have at least 3 characters."
        case .invalidUser(let name): "User [\(name)] already used!\nYou may check from the leaderboard."
        }
    }

    enum ActionType: WSRErrorActionType {
        case ok

        var title: String {
            switch self {
            case .ok: "Ok"
            }
        }

        var isPreferred: Bool {
            switch self {
            default: false
            }
        }

        var isCancel: Bool {
            switch self {
            default: false
            }
        }
    }

    var alertActions: [ActionType] {
        switch self {
        default: [.ok]
        }
    }
}
