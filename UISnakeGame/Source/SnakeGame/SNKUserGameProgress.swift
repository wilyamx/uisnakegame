//
//  SNKUserGameProgress.swift
//  UISnakeGame
//
//  Created by William Rena on 8/1/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import Foundation

class SNKUserGameProgress {
    typealias SNKUserGameProgressData = SNKSnakeGameViewModel.SNKUserGameProgressData
    typealias SNKGameProgressData = SNKSnakeGameViewModel.SNKGameProgressData

    private var gameProgress: [SNKUserGameProgressData]?

    init() {
        if SNKConstants.shared.gameProgress == nil {
            SNKConstants.shared.gameProgress = []
        }
        self.gameProgress = SNKConstants.shared.gameProgress
    }

    func newUserProgress(for user: String, casualGameplay: Bool = false) {
        self.gameProgress = SNKConstants.shared.gameProgress

        guard var allProgress = gameProgress else { return }
        guard !allProgress.contains(where: { $0.user == user }) else { return }

        var progress: SNKUserGameProgressData
        if casualGameplay {
            progress = SNKUserGameProgressData(user: user, mapGameplay: SNKGameProgressData())
        }
        else {
            progress = SNKUserGameProgressData(user: user, mapGameplay: SNKGameProgressData())
        }

        allProgress.append(progress)
        gameProgress = allProgress
        SNKConstants.shared.gameProgress = allProgress
        wsrLogger.info(message: "User: \(user), Casual Gameplay: \(casualGameplay)")
    }

    func saveProgress(for user: String, stage: Int, score: Int, casualGameplay: Bool = false) {
        self.gameProgress = SNKConstants.shared.gameProgress

        guard var allProgress = gameProgress else { return }
        guard let index = allProgress.firstIndex(where: { $0.user == user }) else { return }

        if casualGameplay {
            allProgress[index].casualGameplay = SNKGameProgressData(stage: stage, score: score)
        }
        else {
            allProgress[index].mapGameplay = SNKGameProgressData(stage: stage, score: score)
        }

        gameProgress = allProgress
        SNKConstants.shared.gameProgress = allProgress
        wsrLogger.info(message: "User: \(user), Stage: \(stage), Score: \(score), Casual Gameplay: \(casualGameplay)")
    }

    func getGameProgress(for user: String, casualGameplay: Bool = false) -> SNKGameProgressData? {
        self.gameProgress = SNKConstants.shared.gameProgress

        guard let allProgress = gameProgress else { return nil }
        guard let index = allProgress.firstIndex(where: { $0.user == user }) else { return nil }

        return casualGameplay ? allProgress[index].casualGameplay : allProgress[index].mapGameplay
    }
    
    func getUserGameProgress(for user: String) -> SNKUserGameProgressData? {
        self.gameProgress = SNKConstants.shared.gameProgress

        guard let allProgress = gameProgress else { return nil }
        guard let index = allProgress.firstIndex(where: { $0.user == user }) else { return nil }

        return allProgress[index]
    }

}
