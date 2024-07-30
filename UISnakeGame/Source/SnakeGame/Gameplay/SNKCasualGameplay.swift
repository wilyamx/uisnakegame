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

    static var obstacles: [SNKGridLocation] {
        return [
            SNKGridLocation(row: 5, column: 25),
            SNKGridLocation(row: 6, column: 25),
            SNKGridLocation(row: 7, column: 25),
            SNKGridLocation(row: 8, column: 25),
            SNKGridLocation(row: 9, column: 25),

            SNKGridLocation(row: 15, column: 5),
            SNKGridLocation(row: 15, column: 6),
            SNKGridLocation(row: 15, column: 7),
            SNKGridLocation(row: 15, column: 8),

            SNKGridLocation(row: 25, column: 5),
            SNKGridLocation(row: 25, column: 6),
            SNKGridLocation(row: 25, column: 7),
            SNKGridLocation(row: 25, column: 8),

            SNKGridLocation(row: 32, column: 0),
            SNKGridLocation(row: 33, column: 0),
            SNKGridLocation(row: 34, column: 0),
            SNKGridLocation(row: 35, column: 0),

            SNKGridLocation(row: 39, column: 17),
            SNKGridLocation(row: 39, column: 18),
            SNKGridLocation(row: 39, column: 19),
            SNKGridLocation(row: 39, column: 20)
        ]
    }
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
    func welcomeStageAlert(in viewController: UIViewController, level: Int) async {
        await WSRAsyncAlertController<Bool>(
            message: "Play the classic game mode and gain more points.",
            title: "Survival Mode"
        )
        .addButton(title: "Ok", returnValue: true)
        .register(in: viewController)
    }

    mutating func nextStage() -> SNKStageData? { nil }
}
