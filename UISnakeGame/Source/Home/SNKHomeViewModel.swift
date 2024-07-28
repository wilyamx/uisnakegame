//
//  SNKHomeViewModel.swift
//  UISnakeGame
//
//  Created by William Rena on 7/22/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import Foundation

final class SNKHomeViewModel {
    func isValidUser(name: String) -> Bool {
        return false
    }

    func newUser(name: String) throws {
        guard name.count >= 3 else { throw SNKGameError.minUserCharacterCount(name) }
        guard isAvailableUser(name: name) else { throw SNKGameError.invalidUser(name) }

        SNKConstants.shared.activeUser = name.uppercased()
    }

    private func isAvailableUser(name: String) -> Bool {
        guard let leaderboard = SNKConstants.shared.leaderboardSorted else { return false }
        guard leaderboard.count > 0 else { return false }

        return !leaderboard.contains(where: { $0.name.uppercased() == name.uppercased() })
    }
}
