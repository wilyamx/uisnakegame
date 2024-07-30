//
//  SNKMapBasedGameplay.swift
//  UISnakeGame
//
//  Created by William Rena on 7/30/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

struct SNKMapBasedGameplay: SNKGameplayProtocol {
    var currentStage: Int = 0

    func gridInfo(in containerFrame: CGRect) -> SNKGridInfo {
        var tileSize = SNKConstants.TILE_SIZE
        var mapSize: (rows: Int, columns: Int) = (rows: 0, columns: 0)
        if let config = SNKConstants.shared.gameConfig, config.stages.count > 0 {
            mapSize = stages[0].mapSize()
            let maxDivision = max(mapSize.rows, mapSize.columns)
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

    var stages: [SNKStageData] {
        guard let config = SNKConstants.shared.gameConfig else { return [] }
        return config.stages
    }

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
            message: nil,
            title: "Stage \(level)"
        )
        .addButton(title: "Ok", returnValue: true)
        .register(in: viewController)
    }

    mutating func nextStage() -> SNKStageData? {
        currentStage += 1
        return stages[currentStage - 1]
    }
}
