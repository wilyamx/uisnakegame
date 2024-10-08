//
//  SNKSnakeGameViewModel.swift
//  UISnakeGame
//
//  Created by William Rena on 7/24/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit
import WSRUtils

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

    struct SNKGameProgressData: Codable {
        var stage: Int = 1
        var score: Int = 0
        var levelsCompleted: Bool = false
    }

    struct SNKUserGameProgressData: Codable {
        var user: String
        var casualGameplay: SNKGameProgressData?
        var mapGameplay: SNKGameProgressData?
    }

    @Published var state: SNKGameState = .stop

    var gameplay: SNKGameplayProtocol

    var snakeLength: Int {
        if gameplay is SNKCasualGameplay { return gameplay.defaultSnakeLength}
        return gameplay.snakeLength == 0 ? gameplay.defaultSnakeLength : gameplay.snakeLength
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

    @discardableResult
    func updateForLeaderboard(stagesCompleted: Bool = false) -> Int {
        var datasource = SNKConstants.shared.playMode ? SNKConstants.shared.leaderboardSorted : SNKConstants.shared.leaderboardCasualSorted
        if datasource == nil {
            datasource = []
        }
        guard var leaderboard = datasource, gameplay.score > 0 else { return 0 }
        wsrLogger.info(message: "Check for Ranking. Score: \(gameplay.score)")

        let score = gameplay.score
        let activeUser = SNKConstants.shared.activeUser
        var rank = 0
        var userInfo: SNKLeaderboardItemInfo = SNKLeaderboardItemInfo(
            name: activeUser,
            score: score,
            isCompletedAllLevels: stagesCompleted
        )

        // remove user from existing leaderboard
        if let existingRank = leaderboard.firstIndex(where: { $0.name == activeUser }) {
            rank = existingRank + 1

            let currentIsCompletedAllLevels = leaderboard[existingRank].isCompletedAllLevels
            if score > leaderboard[existingRank].score {
                userInfo = leaderboard.remove(at: existingRank)
                userInfo.score = score
                userInfo.isCompletedAllLevels = currentIsCompletedAllLevels || stagesCompleted
            }
            else {
                wsrLogger.info(message: "Same Rank as #\(rank)!")
                return rank
            }
        }

        // insert user for ranking
        for (index, item) in leaderboard.enumerated() {
            if gameplay.score > item.score  {
                leaderboard.insert(userInfo, at: index)
                rank = index + 1
                wsrLogger.info(message: "Rank as #\(rank)!")
                break
            }
        }

        // add user
        if !leaderboard.contains(where: { $0.name == activeUser }) {
            userInfo.score = score
            leaderboard.append(userInfo)

            wsrLogger.info(message: "Rank as #\(leaderboard.count)!")
        }

        // remove outside limit count in ranking
        if leaderboard.count > SNKConstants.LEADERBOARD_COUNT {
            leaderboard.removeSubrange(SNKConstants.LEADERBOARD_COUNT...leaderboard.count - 1)
        }
        
        if SNKConstants.shared.playMode {
            SNKConstants.shared.leaderboard = leaderboard
        }
        else {
            SNKConstants.shared.leaderboardCasual = leaderboard
        }
        return rank
    }
}
