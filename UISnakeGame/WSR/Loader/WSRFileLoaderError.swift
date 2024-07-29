//
//  WSRFileLoaderError.swift
//  UISnakeGame
//
//  Created by William Rena on 5/11/23.
//

import UIKit

enum WSRFileLoaderError2: Error, LocalizedError, WSRActionableError {
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
            return ""
        }

        var isPreferred: Bool {
            return false
        }

        var isCancel: Bool {
            return false
        }
    }

    var alertActions: [ActionType] {
        [.ok]
    }
}

enum WSRFileLoaderError: Error, CustomStringConvertible {
    case fileNotFound(String)
    case fileCannotLoad(Error)
    case parsing(DecodingError?)
    case unknown
    
    var localizedDescription: String {
        // user feedback
        switch self {
        case .fileNotFound, .fileCannotLoad, .parsing, .unknown:
            return "Sorry, something went wrong."
        }
    }
    
    var description: String {
        //info for debugging
        switch self {
        case .unknown: return "Unknown Error"
        case .fileNotFound(let filePath): return "Invalid file path: \(filePath)"
        case .fileCannotLoad(let error): return "File cannot load: \(error)"
        case .parsing(let error):
            return "Parsing error \(error?.localizedDescription ?? "")"
        }
    }
}
