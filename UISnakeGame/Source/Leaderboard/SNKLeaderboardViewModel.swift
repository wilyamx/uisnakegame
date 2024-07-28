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
        var isCompletedAllLevels: Bool
    }

    private(set) var sections: [Section] = []

    @Published var items: [Section: [Item]] = [:]

    func load() async {
        sections = [.main]

        guard let leaderboard = SNKConstants.shared.leaderboardSorted
        else {
            let leaderboard = dummyLeaderboard()
            SNKConstants.shared.leaderboard = leaderboard
            items[.main] = leaderboard.map({ itemInfo in
                .scoreItem(itemInfo)
            })
            return
        }

        items[.main] = leaderboard.map({ itemInfo in
            .scoreItem(itemInfo)
        })
    }

    private func dummyLeaderboard() -> [ItemInfo] {
        return [
            ItemInfo(name: "Angelica", score: 1234, isCompletedAllLevels: true),
            ItemInfo(name: "Jamaica", score: 567, isCompletedAllLevels: false),
            ItemInfo(name: "William", score: 890, isCompletedAllLevels: true),
            ItemInfo(name: "Lorem", score: 300, isCompletedAllLevels: false),
            ItemInfo(name: "Ipsum", score: 54, isCompletedAllLevels: false),
            ItemInfo(name: "Antonio", score: 1234, isCompletedAllLevels: true),
            ItemInfo(name: "Dolor", score: 54, isCompletedAllLevels: false),
            ItemInfo(name: "Dupidatat", score: 657, isCompletedAllLevels: true),
            ItemInfo(name: "Excepteur", score: 231, isCompletedAllLevels: false),
            ItemInfo(name: "Angela", score: 1234, isCompletedAllLevels: true),
            ItemInfo(name: "Exercitation", score: 878, isCompletedAllLevels: true)
        ].sorted { lhs, rhs in
            return (lhs.score, rhs.name) > (rhs.score, lhs.name)
        }
    }
}
