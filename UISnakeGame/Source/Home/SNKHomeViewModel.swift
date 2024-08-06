//
//  SNKHomeViewModel.swift
//  UISnakeGame
//
//  Created by William Rena on 7/22/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

final class SNKHomeViewModel {
    private typealias ItemInfo = SNKLeaderboardViewModel.ItemInfo
    typealias SNKUserGameProgressData = SNKSnakeGameViewModel.SNKUserGameProgressData
    typealias SNKGameProgressData = SNKSnakeGameViewModel.SNKGameProgressData

    private let fileLoader = WSRFileLoader()
    private let gameProgress = SNKUserGameProgress()
    private var userGameProgressData: SNKUserGameProgressData?

    @Published var activeUser: String?

    func loadGameConfiguration(from filename: String) async throws {
        guard SNKConstants.shared.gameConfig == nil else { return }

        SNKConstants.shared.gameConfig = try await fileLoader.loadJSON(
            SNKConstants.DEFAULT_GAME_CONFIG_FILE, SNKGameConfiguration.self
        ) as? SNKGameConfiguration
    }

    func loadUserGameProgress(of user: String) async {
        userGameProgressData = gameProgress.getUserGameProgress(for: SNKConstants.shared.activeUser)
        if let userGameProgressData = userGameProgressData {
            if let gameplay = userGameProgressData.mapGameplay {
                wsrLogger.info(message: "Progress (Map Gameplay): \(gameplay)")
            }
            if let gameplay = userGameProgressData.casualGameplay {
                wsrLogger.info(message: "Progress (Casual Gameplay): \(gameplay)")
            }
        }
        else {
            wsrLogger.info(message: "NO Progress for \(user)")
        }
    }

    func newUser(user: String) throws {
        guard user.count >= 3 else { throw SNKGameError.minUserCharacterCount(user) }
        guard isAvailableUser(name: user) else { throw SNKGameError.invalidUser(user) }

        let nameToSave = user.uppercased()
        SNKConstants.shared.activeUser = nameToSave
        gameProgress.newUserProgress(for: nameToSave)
        
        activeUser = nameToSave
    }

    func applyDummyLeaderboard() async {
        guard SNKConstants.shared.leaderboard == nil else { return }

        SNKConstants.shared.leaderboard = [
            ItemInfo(name: "ANGELICA", score: 1234, isCompletedAllLevels: true),
            ItemInfo(name: "JAMAICA", score: 567, isCompletedAllLevels: false),
            ItemInfo(name: "WILLIAM", score: 890, isCompletedAllLevels: true),
            ItemInfo(name: "LOREM", score: 300, isCompletedAllLevels: false),
            ItemInfo(name: "IPSUM", score: 1, isCompletedAllLevels: false),
            ItemInfo(name: "ANTONIO", score: 1234, isCompletedAllLevels: true),
            ItemInfo(name: "DOLOR", score: 1, isCompletedAllLevels: false),
            ItemInfo(name: "DUPIDATAR", score: 657, isCompletedAllLevels: true),
            ItemInfo(name: "EXCEPTEUR", score: 231, isCompletedAllLevels: false),
            ItemInfo(name: "ANGELA", score: 1234, isCompletedAllLevels: true),
            ItemInfo(name: "EXERCITATION", score: 878, isCompletedAllLevels: true)
        ].sorted { lhs, rhs in
            return (lhs.score, rhs.name) > (rhs.score, lhs.name)
        }
    }

    func applyDummyLeaderboardCasual() async {
        guard SNKConstants.shared.leaderboardCasual == nil else { return }

        SNKConstants.shared.leaderboardCasual = [
            ItemInfo(name: "GOKOU", score: 1234),
            ItemInfo(name: "VEGETA", score: 300),
            ItemInfo(name: "FERNANDO", score: 555),
            ItemInfo(name: "JM", score: 300),
            ItemInfo(name: "SIX", score: 1),
            ItemInfo(name: "DEXTER", score: 1234),
            ItemInfo(name: "ANTONIO", score: 1),
            ItemInfo(name: "PEDRO", score: 45),
            ItemInfo(name: "EUGENE", score: 231),
            ItemInfo(name: "CASS", score: 100),
            ItemInfo(name: "MIA", score: 878)
        ].sorted { lhs, rhs in
            return (lhs.score, rhs.name) > (rhs.score, lhs.name)
        }
    }

    func resetData() {
        // leaderboards
        SNKConstants.shared.leaderboard = []
        SNKConstants.shared.leaderboardCasual = []

        // game progress
        SNKConstants.shared.showTheMapGameplayObjective = false
        SNKConstants.shared.showTheCasualGameplayObjective = false

        let activeUser = SNKConstants.shared.activeUser
        guard activeUser.count >= 3 else { return }

        SNKConstants.shared.gameProgress = [
            SNKUserGameProgressData(
                user: activeUser,
                casualGameplay: SNKGameProgressData(),
                mapGameplay: SNKGameProgressData()
            )
        ]

        wsrLogger.info(message: "User: \(activeUser)")
    }

    // MARK: - Private Methods
    
    private func isAvailableUser(name: String) -> Bool {
        let datasource = SNKConstants.shared.playMode ? SNKConstants.shared.leaderboardSorted : SNKConstants.shared.leaderboardCasualSorted
        guard let leaderboard = datasource else { return true }
        guard leaderboard.count > 0 else { return true }

        return !leaderboard.contains(where: { $0.name.uppercased() == name.uppercased() })
    }
}
