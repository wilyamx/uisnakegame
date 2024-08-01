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
        SNKConstants.shared.gameProgress = gameProgress
        wsrLogger.info(message: "User: \(user), Casual Gameplay: \(casualGameplay)")
    }

    func saveProgress(for user: String, stage: Int, score: Int, casualGameplay: Bool = false) {
        guard var gameProgress = gameProgress else { return }
        guard let index = gameProgress.firstIndex(where: { $0.user == user }) else { return }

        if casualGameplay {
            gameProgress[index].casualGameplay = SNKGameProgressData(stage: stage, score: score)
        }
        else {
            gameProgress[index].mapGameplay = SNKGameProgressData(stage: stage, score: score)
        }

        SNKConstants.shared.gameProgress = gameProgress
        wsrLogger.info(message: "User: \(user), Stage: \(stage), Score: \(score)")
    }
}
