//
//  SNKCasualGameplay.swift
//  UISnakeGame
//
//  Created by William Rena on 7/30/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

struct SNKCasualGameplay: SNKGameplayProtocol {
    typealias SNKGridLocation = SNKGrid.SNKGridLocation

    var currentStage: Int = 1
    var score: Int = 0
    var snakeLength: Int = 0
    var isLastStage: Bool {
        get { true }
        set { }
    }

    var stages: [SNKStageData] { [] }
    var duration: Int {
#if DEV
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.SNAKE_LENGTH }
        return config.durationInSeconds
#elseif TEST
        return SNKConstants.GAME_DURATION_IN_SECONDS
#else
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.SNAKE_LENGTH }
        return config.durationInSeconds
#endif
    }
    var defaultSnakeLength: Int {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.SNAKE_LENGTH }
        return config.snake.defaultLength
    }
    var minimumSpeed: CGFloat {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.MINIMUM_SPEED }
        return config.minimumSpeed
    }
    var minimumFoodCredit: Int {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.MINIMUM_FOOD_CREDIT }
        return config.minimumFoodCredit
    }
    var isTimeBasedStage: Bool {
        guard let config = SNKConstants.shared.gameConfig else { return true }
        return config.durationInSeconds > 0 && config.foodSpawnCount == 0
    }

    func gridInfo(in containerFrame: CGRect) -> SNKGridInfo {
        var tileSize = SNKConstants.TILE_SIZE
        if let config = SNKConstants.shared.gameConfig, config.stages.count > 0 {
            tileSize = CGFloat(config.grid.size)
        }
        let rows = Int(containerFrame.height / tileSize)
        let columns = Int(containerFrame.width / tileSize)
        let area = CGSize(width: tileSize * CGFloat(columns), height: tileSize * CGFloat(rows))
        return SNKGridInfo(rows: rows, columns: columns, area: area, tileSize: tileSize)
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
            message: "Avoid these randomized obstacles to survive. The fastest time to eat more foods, the better!",
            title: "SURVIVAL MODE"
        )
        .addButton(title: "Ok", returnValue: "Ok")
        .register(in: viewController)
    }

    @MainActor
    @discardableResult
    func completedStageAlert(in viewController: UIViewController, score: Int) async -> String {
        let pointsMessage = score == 0 ? "Sorry, you got no point!" : "You got \(score) point(s)."
        return await WSRAsyncAlertController<String>(
            message: "You survived within the time limit.\n\(pointsMessage)",
            title: "CONGRATULATIONS!"
        )
        .addButton(title: "Play Again", returnValue: "Play Again")
        .register(in: viewController)
    }

    @MainActor
    @discardableResult
    func gameOverStageAlert(in viewController: UIViewController, score: Int) async -> String {
        let pointsMessage = score == 0 ? "Sorry, you got no point!" : "You got \(score) point(s)."
        return await WSRAsyncAlertController<String>(
            message: "\(pointsMessage)",
            title: "GAME OVER!"
        )
        .addButton(title: "Play Again", isPreferred: true, returnValue: "Play Again")
        .addButton(title: "Quit", returnValue: "Quit")
        .register(in: viewController)
    }

    @MainActor
    func gameplayAlert(in viewController: UIViewController) async {
        await WSRAsyncAlertController<String>(
            message: "Eat more foods to increase your points within the time limit. Beat the users in the leaderboard!",
            title: "OBJECTIVE"
        )
        .addButton(title: "Ok", returnValue: "Ok")
        .register(in: viewController)
    }

    mutating func earnedNewPoints(stageScore: Int) {
        score += stageScore
        wsrLogger.info(message: "Stage Score: \(stageScore), Total Score: \(score)")
    }
    
    mutating func nextStage() {
        currentStage = 1
        wsrLogger.info(message: "Next Stage: \(currentStage)")
    }
    
    mutating func restoreProgress() {
        guard let progress = SNKUserGameProgress().getGameProgress(
            for: SNKConstants.shared.activeUser, casualGameplay: true
        ) else { return }
        currentStage = progress.stage
        score = progress.score
        wsrLogger.info(message: "\(progress)")
    }

    mutating func restart() {
        currentStage = 1
    }

    func currentStageData() -> SNKStageData? { nil }

    func saveProgress() {
        SNKUserGameProgress().saveProgress(
            for: SNKConstants.shared.activeUser, stage: currentStage, score: score, casualGameplay: true
        )
    }
}
