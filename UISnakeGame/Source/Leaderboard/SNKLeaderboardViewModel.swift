//
//  SNKLeaderboardViewModel.swift
//  UISnakeGame
//
//  Created by William Rena on 7/23/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import Foundation

final class SNKLeaderboardViewModel {
    enum Section: Hashable {
        case main
    }

    enum Item: Hashable {
        case scoreItem(ItemInfo)
    }

    struct ItemInfo: Hashable, Codable {
        static func == (lhs: ItemInfo, rhs: ItemInfo) -> Bool {
            lhs.hashValue == rhs.hashValue
        }

        var id = UUID().uuidString
        var name: String
        var score: Int = 0
        var isCompletedAllLevels: Bool = false
    }

    private(set) var sections: [Section] = []

    @Published var items: [Section: [Item]] = [:]

    func load() async {
        sections = [.main]

        let datasource = SNKConstants.shared.playMode ? SNKConstants.shared.leaderboardSorted : SNKConstants.shared.leaderboardCasualSorted
        guard let leaderboard = datasource
        else {
            items[.main] = []
            return
        }

        items[.main] = leaderboard.map({ itemInfo in
            .scoreItem(itemInfo)
        })
    }
}
