//
//  SNKMapBasedGameplay.swift
//  UISnakeGame
//
//  Created by William Rena on 7/30/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit
import WSRComponents
import WSRUtils

struct SNKMapBasedGameplay: SNKGameplayProtocol {
    typealias SNKGameProgressData = SNKSnakeGameViewModel.SNKGameProgressData

    var currentStage: Int = 1
    var score: Int = 0
    var snakeLength: Int = 0
    var isLastStage: Bool {
        get { currentStage == stages.count }
        set { }
    }

    var stages: [SNKStageData] {
        guard let config = SNKConstants.shared.gameConfig else { return [] }
        return config.stages.sorted { lhs, rhs in
            return lhs.stage < rhs.stage
        }
    }
    var duration: Int {
#if DEV
        guard let stageData = currentStageData() else { return SNKConstants.GAME_DURATION_IN_SECONDS }
        return stageData.durationInSeconds
#elseif TEST
        return SNKConstants.GAME_DURATION_IN_SECONDS
#else
        guard let stageData = currentStageData() else { return SNKConstants.GAME_DURATION_IN_SECONDS }
        return stageData.durationInSeconds
#endif
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
    var isTimeBasedStage: Bool {
        guard let stageData = currentStageData() else { return true }
        return (stageData.durationInSeconds > 0 && stageData.foodSpawnCount == 0) || stageData.durationInSeconds > 0
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
    func gameplayAlert(in viewController: UIViewController) async {
        await WSRAsyncAlertController<String>(
            message: "Eat these spawn foods to increase your points. SURVIVE! More amazing and challenging obtacle maps awaits you. Happy gaming!",
            title: "OBJECTIVE"
        )
        .addButton(title: "Ok", returnValue: "Ok")
        .register(in: viewController)
    }
    
    @MainActor
    func welcomeStageAlert(in viewController: UIViewController) async {
        await WSRAsyncAlertController<String>(
            message: currentStageData()?.stageName,
            title: "STAGE \(currentStage)"
        )
        .addButton(title: "Ok", returnValue: "Ok")
        .register(in: viewController)
    }

    @MainActor
    @discardableResult
    func completedStageAlert(in viewController: UIViewController, score: Int) async -> String {
        if isLastStage {
            await WSRAsyncAlertController<String>(
                message: "ALL STAGES COMPLETED!\n\(score == 0 ? "Sorry, you got no point!" : "You got \(score) point(s).")",
                title: "C O N G R A T U L A T I O N S !"
            )
            .addButton(title: "Play From Beginning", returnValue: "Play From Beginning")
            .register(in: viewController)
        }
        else {
            await WSRAsyncAlertController<String>(
                message: "You will proceed to the next stage.\n\(score == 0 ? "Sorry, you got no point!" : "You got \(score) point(s).")",
                title: "STAGE \(currentStage) COMPLETE!"
            )
            .addButton(title: "Next Stage", returnValue: "Next Stage")
            .register(in: viewController)
        }
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

    @MainActor
    func flexibleSnakeAlert(in viewController: UIViewController) async {
        await WSRAsyncAlertController<String>(
            message: "Snake has the ability to overlap it's body.",
            title: "FLEXIBLE SNAKE"
        )
        .addButton(title: "Ok", returnValue: "Ok")
        .register(in: viewController)
    }
    
    @MainActor
    func invisibleSnakeAlert(in viewController: UIViewController) async {
        await WSRAsyncAlertController<String>(
            message: "Snake has the ability to pass obstacles.",
            title: "INVISIBLE SNAKE"
        )
        .addButton(title: "Ok", returnValue: "Ok")
        .register(in: viewController)
    }

    @MainActor
    func hardHeadedSnakeAlert(in viewController: UIViewController) async {
        await WSRAsyncAlertController<String>(
            message: "Snake has the ability to destroy obstacles.",
            title: "HARD HEADED SNAKE"
        )
        .addButton(title: "Ok", returnValue: "Ok")
        .register(in: viewController)
    }

    mutating func earnedNewPoints(stageScore: Int) {
        score += stageScore
        wsrLogger.info(message: "Stage Score: \(stageScore), Total Score: \(score)")
    }

    mutating func nextStage() {
        if currentStage < stages.count {
            currentStage += 1
        }
        wsrLogger.info(message: "Next Stage: \(currentStage)")
    }

    mutating func restoreProgress() {
        guard let progress = SNKUserGameProgress().getGameProgress(for: SNKConstants.shared.activeUser) else { return }
        currentStage = progress.stage
        score = progress.score
        wsrLogger.info(message: "\(progress)")
    }

    mutating func restart() {
        currentStage = 1
        SNKUserGameProgress().saveProgress(for: SNKConstants.shared.activeUser, stage: 1, score: score)
    }

    func hasMoreFoodAvailable(eatenFoodCount: Int) -> Bool {
        guard let stageData = currentStageData() else { return true }
#if DEV
        return eatenFoodCount == stageData.foodSpawnCount
#elseif TEST
        return eatenFoodCount == SNKConstants.FOOD_SPAWN_COUNT
#else
        return eatenFoodCount == stageData.foodSpawnCount
#endif
    }

    func currentStageData() -> SNKStageData? {
        return stages[currentStage - 1]
    }

    func saveProgress() {
        SNKUserGameProgress().saveProgress(for: SNKConstants.shared.activeUser, stage: currentStage, score: score)
    }
}
