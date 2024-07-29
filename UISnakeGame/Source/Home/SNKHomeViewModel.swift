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

    let fileLoader = WSRFileLoader()

    var configuration: SNKGameConfiguration?

    func loadGameConfiguration(from filename: String) async throws {
        configuration = try await fileLoader.loadJSON(
            "default-game-config.json", SNKGameConfiguration.self
        ) as? SNKGameConfiguration
    }

    func isValidUser(name: String) -> Bool {
        return false
    }

    func newUser(name: String) throws {
        guard name.count >= 3 else { throw SNKGameError.minUserCharacterCount(name) }
        guard isAvailableUser(name: name) else { throw SNKGameError.invalidUser(name) }

        SNKConstants.shared.activeUser = name.uppercased()
    }

    func applyDummyLeaderboard() async {
        guard SNKConstants.shared.leaderboard == nil else { return }

        SNKConstants.shared.leaderboard = [
            ItemInfo(name: "ANGELICA", score: 1234, isCompletedAllLevels: true),
            ItemInfo(name: "JAMAICA", score: 567, isCompletedAllLevels: false),
            ItemInfo(name: "WILLIAM", score: 890, isCompletedAllLevels: true),
            ItemInfo(name: "LOREM", score: 300, isCompletedAllLevels: false),
            ItemInfo(name: "IPSUM", score: 54, isCompletedAllLevels: false),
            ItemInfo(name: "ANTONIO", score: 1234, isCompletedAllLevels: true),
            ItemInfo(name: "DOLOR", score: 54, isCompletedAllLevels: false),
            ItemInfo(name: "DUPIDATAR", score: 657, isCompletedAllLevels: true),
            ItemInfo(name: "EXCEPTEUR", score: 231, isCompletedAllLevels: false),
            ItemInfo(name: "ANGELA", score: 1234, isCompletedAllLevels: true),
            ItemInfo(name: "EXERCITATION", score: 878, isCompletedAllLevels: true)
        ].sorted { lhs, rhs in
            return (lhs.score, rhs.name) > (rhs.score, lhs.name)
        }
    }

    // MARK: - Private Methods
    
    private func isAvailableUser(name: String) -> Bool {
        guard let leaderboard = SNKConstants.shared.leaderboardSorted else { return false }
        guard leaderboard.count > 0 else { return false }

        return !leaderboard.contains(where: { $0.name.uppercased() == name.uppercased() })
    }
}
