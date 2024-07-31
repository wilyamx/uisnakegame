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

    var stages: [SNKStageData] { [] }
    var duration: Int {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.SNAKE_LENGTH }
        return config.durationInSeconds
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
            message: "Play the classic game mode and gain more points.",
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

    mutating func earnedNewPoints(stageScore: Int) {
        score += stageScore
        wsrLogger.info(message: "Stage Score: \(stageScore), Total Score: \(score)")
    }
    
    mutating func nextStage() {
        currentStage = 1
        wsrLogger.info(message: "Current Stage: \(currentStage)")
    }
    
    func currentStageData() -> SNKStageData? { nil }
}
