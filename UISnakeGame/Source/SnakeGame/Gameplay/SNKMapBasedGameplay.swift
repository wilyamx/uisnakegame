//
//  SNKMapBasedGameplay.swift
//  UISnakeGame
//
//  Created by William Rena on 7/30/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

struct SNKMapBasedGameplay: SNKGameplayProtocol {
    var tileSize: CGFloat {
        guard let config = SNKConstants.shared.gameConfig,
              config.stages.count > 0 else { return SNKConstants.TILE_SIZE }
        return CGFloat(config.grid.size + 10)
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
    func welcomeStageAlert(in viewController: UIViewController, level: Int) async {
        await WSRAsyncAlertController<Bool>(
            message: nil,
            title: "Stage \(level)"
        )
        .addButton(title: "Ok", returnValue: true)
        .register(in: viewController)
    }
}
