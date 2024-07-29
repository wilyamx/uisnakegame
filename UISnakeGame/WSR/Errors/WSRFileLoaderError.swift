//
//  WSRFileLoaderError.swift
//  UISnakeGame
//
//  Created by William Rena on 5/11/23.
//

import UIKit

enum WSRFileLoaderError: Error, LocalizedError, WSRActionableError {
    typealias CustomErrorActionType = ActionType

    case fileNotFound(String)
    case fileCannotLoad(Error)
    case parsing(Error)

    var title: String? {
        switch self {
        case .fileNotFound: "File not found!"
        case .fileCannotLoad: "File cannot be load!"
        case .parsing: "Parsing error!"
        }
    }

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let filePath): "Invalid file path: \(filePath)"
        case .fileCannotLoad: "File is corrupted!"
        case .parsing: "Parsing error!"
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
        [.ok]
    }
}
