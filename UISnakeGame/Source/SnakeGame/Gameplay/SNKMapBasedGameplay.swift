//
//  SNKMapBasedGameplay.swift
//  UISnakeGame
//
//  Created by William Rena on 7/30/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

struct SNKMapBasedGameplay: SNKGameplayProtocol {
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
