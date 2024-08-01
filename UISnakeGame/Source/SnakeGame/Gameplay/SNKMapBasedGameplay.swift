//
//  SNKMapBasedGameplay.swift
//  UISnakeGame
//
//  Created by William Rena on 7/30/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

struct SNKMapBasedGameplay: SNKGameplayProtocol {
    typealias SNKGameProgressData = SNKSnakeGameViewModel.SNKGameProgressData

    var currentStage: Int = 1
    var score: Int = 0
    var snakeLength: Int = 0

    var stages: [SNKStageData] {
        guard let config = SNKConstants.shared.gameConfig else { return [] }
        return config.stages
    }
    var duration: Int {
        guard let stageData = currentStageData() else { return SNKConstants.GAME_DURATION_IN_SECONDS }
        return stageData.durationInSeconds
    }
    var defaultSnakeLength: Int {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.SNAKE_LENGTH }
        return config.snake.defaultLength
    }
    var minimumSpeed: CGFloat {
        guard let stageData = currentStageData() else { return SNKConstants.MINIMUM_SPEED }
        return stageData.minimumSpeed
    }
    var minimumFoodCredit: Int {
        guard let stageData = currentStageData() else { return SNKConstants.MINIMUM_FOOD_CREDIT }
        return stageData.minimumFoodCredit
    }

    func gridInfo(in containerFrame: CGRect) -> SNKGridInfo {
        var tileSize = SNKConstants.TILE_SIZE
        var mapSize: (rows: Int, columns: Int) = (rows: 0, columns: 0)
        if let config = SNKConstants.shared.gameConfig, config.stages.count > 0 {
            mapSize = stages[currentStage - 1].mapSize()
            let maxDivision = min(mapSize.rows, mapSize.columns)
            tileSize = CGFloat(min(
                Int(containerFrame.width / CGFloat(maxDivision)),
                Int(containerFrame.height / CGFloat(maxDivision))
            ))
        }
        let area = CGSize(
            width: tileSize * CGFloat(mapSize.columns),
            height: tileSize * CGFloat(mapSize.rows)
        )
        return SNKGridInfo(rows: mapSize.rows, columns: mapSize.columns, area: area, tileSize: tileSize)
    }

    func grid(frame: CGRect, tileSize: CGFloat) -> SNKGrid {
        guard frame.size != .zero, tileSize != 0 else { fatalError("Check parameter values!") }
        return SNKGrid(frame: frame, size: tileSize)
    }
    
    func gridView(frame: CGRect, tileSize: CGFloat) -> SNKGridView {
        guard frame.size != .zero, tileSize != 0 else { fatalError("Check parameter values!") }
        return SNKGridView(frame: frame, size: tileSize)
    }

    @MainActor
    @discardableResult
    func welcomeStageAlert(in viewController: UIViewController) async -> String {
        return await WSRAsyncAlertController<String>(
            message: nil,
            title: "STAGE \(currentStage)"
        )
        .addButton(title: "Ok", returnValue: "Ok")
        .register(in: viewController)
    }

    @MainActor
    @discardableResult
    func completedStageAlert(in viewController: UIViewController, score: Int) async -> String {
        await WSRAsyncAlertController<String>(
            message: "You will proceed to the next stage.\n\(score == 0 ? "Sorry, you got no point!" : "You got \(score) point(s).")",
            title: "STAGE \(currentStage - 1) COMPLETE!"
        )
        .addButton(title: "Next Stage", returnValue: "Next Stage")
        .register(in: viewController)
    }

    @MainActor
    @discardableResult
    func gameOverStageAlert(in viewController: UIViewController, score: Int) async -> String {
        return await WSRAsyncAlertController<String>(
            message: "\(score == 0 ? "Sorry, you got no point!" : "You got \(score) point(s).")",
            title: "GAME OVER!"
        )
        .addButton(title: "Play Again", isPreferred: true, returnValue: "Play Again")
        .addButton(title: "Quit", returnValue: "Quit")
        .register(in: viewController)
    }

    mutating func earnedNewPoints(stageScore: Int) {
        score += stageScore
        wsrLogger.info(message: "Stage Score: \(stageScore), Total Score: \(score)")
    }

    mutating func nextStage() {
        currentStage += 1
        wsrLogger.info(message: "Current Stage: \(currentStage)")
    }

    mutating func restoreProgress() {
        guard let progress = SNKUserGameProgress().getUserProgress(for: SNKConstants.shared.activeUser) else { return }
        currentStage = progress.stage
        score = progress.score
        wsrLogger.info(message: "\(progress)")
    }

    func currentStageData() -> SNKStageData? {
        return stages[currentStage - 1]
    }

    func saveProgress() {
        SNKUserGameProgress().saveProgress(for: SNKConstants.shared.activeUser, stage: currentStage, score: score)
    }
}
