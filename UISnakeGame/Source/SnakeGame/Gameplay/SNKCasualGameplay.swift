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

    var stages: [SNKStageData] { [] }

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
        return await WSRAsyncAlertController<String>(
            message: "You survived within the time limit.\nYou got \(score) point(s).",
            title: "CONGRATULATIONS!"
        )
        .addButton(title: "Play Again", returnValue: "Play Again")
        .register(in: viewController)
    }

    @MainActor
    @discardableResult
    func gameOverStageAlert(in viewController: UIViewController, score: Int) async -> String {
        return await WSRAsyncAlertController<String>(
            message: "You got \(score) point(s).",
            title: "GAME OVER!"
        )
        .addButton(title: "Play Again", isPreferred: true, returnValue: "Play Again")
        .addButton(title: "Quit", returnValue: "Quit")
        .register(in: viewController)
    }

    mutating func nextStage() {
        currentStage = 1
        wsrLogger.info(message: "Current Stage: \(currentStage)")
    }
    
    mutating func currentStageData() -> SNKStageData? { nil }
}