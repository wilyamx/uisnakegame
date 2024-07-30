//
//  SNKCasualGameplay.swift
//  UISnakeGame
//
//  Created by William Rena on 7/30/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

struct SNKCasualGameplay: SNKGameplayProtocol {
    var tileSize: CGFloat {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.TILE_SIZE }
        return CGFloat(config.grid.size)
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
            message: "Play the classic game mode and gain more points.",
            title: "Survival Mode"
        )
        .addButton(title: "Ok", returnValue: true)
        .register(in: viewController)
    }
}
