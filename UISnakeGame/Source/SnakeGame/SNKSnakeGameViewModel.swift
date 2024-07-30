//
//  SNKSnakeGameViewModel.swift
//  UISnakeGame
//
//  Created by William Rena on 7/24/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

final class SNKSnakeGameViewModel {
    enum SNKGameState: Equatable {
        case start
        case play
        case stop
        case pause
        case restart
        case newStageAlert
        case stageComplete(Int)
        case gameOver(Int)
    }

    @Published var state: SNKGameState = .stop

    var gameplay: SNKGameplayProtocol?

    enum SNKDirection {
        case left
        case up
        case right
        case down

        var opposite: SNKDirection {
            switch self {
            case .left: return .right
            case .up: return .down
            case .right: return .left
            case .down: return .up
            }
        }

        init(_ swipeDirection: UISwipeGestureRecognizer.Direction) {
            if swipeDirection.contains(.up) { self = .up }
            else if swipeDirection.contains(.down) { self = .down }
            else if swipeDirection.contains(.left) { self = .left }
            else { self = .right }
        }
    }

    var showGrid: Bool { SNKConstants.shared.displayGrid }

    var currentStage: Int { SNKConstants.shared.currentStage }
    var nextStage: Int { currentStage + 1 }

    func newGameplay() -> SNKGameplayProtocol {
        SNKConstants.shared.playMode ? SNKMapBasedGameplay() : SNKCasualGameplay()
    }
}
