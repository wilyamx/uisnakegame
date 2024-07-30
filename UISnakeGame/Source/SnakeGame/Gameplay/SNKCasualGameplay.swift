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

    var currentStage: Int = 0

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

    var stages: [SNKStageData] { [] }

    // MARK: - Methods

    func grid(frame: CGRect, tileSize: CGFloat) -> SNKGrid {
        guard frame.size != .zero, tileSize != 0 else { fatalError("Check parameter values!") }
        return SNKGrid(frame: frame, size: tileSize)
    }

    func gridView(frame: CGRect, tileSize: CGFloat) -> SNKGridView {
        guard frame.size != .zero, tileSize != 0 else { fatalError("Check parameter values!") }
        return SNKGridView(frame: frame, size: tileSize)
    }

    @MainActor
    func welcomeStageAlert(in viewController: UIViewController, stage: Int) async {
        await WSRAsyncAlertController<String>(
            message: "Play the classic game mode and gain more points.",
            title: "SURVIVAL MODE"
        )
        .addButton(title: "Ok", returnValue: "Ok")
        .register(in: viewController)
    }

    @MainActor
    func completedStageAlert(in viewController: UIViewController, stage: Int) async {
        await WSRAsyncAlertController<String>(
            message: "You survived within the time limit.",
            title: "CONGRATULATIONS!"
        )
        .addButton(title: "Play More", returnValue: "Play More")
        .register(in: viewController)
    }

    mutating func nextStage() -> SNKStageData? { nil }
}
