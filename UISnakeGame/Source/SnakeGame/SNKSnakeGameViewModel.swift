//
//  SNKSnakeGameViewModel.swift
//  UISnakeGame
//
//  Created by William Rena on 7/24/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

final class SNKSnakeGameViewModel {
    typealias SNKLeaderboardItemInfo = SNKLeaderboardViewModel.ItemInfo

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

    var gameplay: SNKGameplayProtocol

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

    init() {
        gameplay = SNKConstants.shared.playMode ? SNKMapBasedGameplay() : SNKCasualGameplay()
    }

    /**
        The gameplay from SNKSnakeGame will deinit everytime new stage will create.
        We need to save the progress of previous stage.
     */
    func update(gameplay: SNKGameplayProtocol) {
        self.gameplay = gameplay
    }

    func updateForLeaderboard() -> Int {
        guard var leaderboard = SNKConstants.shared.leaderboardSorted, gameplay.score > 0 else { return 0 }
        wsrLogger.info(message: "Total Score: \(gameplay.score)")

        var rank = 0
        let activeUser = SNKConstants.shared.activeUser

        for (index, item) in leaderboard.enumerated() {
            wsrLogger.info(message: "\(gameplay.score) >= \(item.score)")
            if gameplay.score >= item.score && item.name != activeUser  {
                let userInfo = SNKLeaderboardItemInfo(
                    name: activeUser, score: gameplay.score, isCompletedAllLevels: false
                )
                leaderboard.insert(userInfo, at: index)
                rank = index + 1
                wsrLogger.info(message: "You rank as #\(rank)!")
                break
            }
        }

        if leaderboard.count > SNKConstants.LEADERBOARD_COUNT {
            leaderboard.removeSubrange(SNKConstants.LEADERBOARD_COUNT...leaderboard.count - 1)
        }
        
        SNKConstants.shared.leaderboard = leaderboard
        return rank
    }
}
