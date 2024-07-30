//
//  SNKCasualGameplay.swift
//  UISnakeGame
//
//  Created by William Rena on 7/30/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

struct SNKCasualGameplay: SNKGameplayProtocol {
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
