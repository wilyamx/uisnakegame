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

    struct ItemInfo: Hashable {
        static func == (lhs: ItemInfo, rhs: ItemInfo) -> Bool {
            lhs.hashValue == rhs.hashValue
        }

        var id = UUID().uuidString
        var name: String = ""
        var score: Int = 0
        var isCompletedAllLevels: Bool = false
    }

    private(set) var sections: [Section] = []

    @Published var items: [Section: [Item]] = [:]

    func load() async {
        sections = [.main]

        items[.main] = [
            .scoreItem(ItemInfo(name: "Player 1", score: 5000, isCompletedAllLevels: true)),
            .scoreItem(ItemInfo(name: "Player 2", score: 4000, isCompletedAllLevels: true)),
            .scoreItem(ItemInfo(name: "Player 3", score: 3000, isCompletedAllLevels: true)),
            .scoreItem(ItemInfo(name: "Player 4", score: 2000, isCompletedAllLevels: false)),
            .scoreItem(ItemInfo(name: "Player 5", score: 1000, isCompletedAllLevels: false)),
            .scoreItem(ItemInfo(name: "Player 6", score: 2000, isCompletedAllLevels: false)),
            .scoreItem(ItemInfo(name: "Player 7", score: 800, isCompletedAllLevels: false)),
            .scoreItem(ItemInfo(name: "Player 8", score: 600, isCompletedAllLevels: false)),
            .scoreItem(ItemInfo(name: "Player 9", score: 500, isCompletedAllLevels: false)),
            .scoreItem(ItemInfo(name: "Player 10", score: 20, isCompletedAllLevels: false))
        ]
    }
}
