//
//  SNKHomeCoordinator.swift
//  UISnakeGame
//
//  Created by William Rena on 7/22/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

class SNKHomeCoordinator: WSRCoordinatorProtocol {
    var childCoordinators = [WSRCoordinatorProtocol]()
    var navigationController: UINavigationController?

    var window: UIWindow?

    init(window: UIWindow?, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
    }

    func start() {
        let viewController = SNKHomeViewController()
        viewController.coordinator = self

        navigationController?.pushViewController(viewController, animated: false)

        guard let navigationController = navigationController
        else {
            window?.rootViewController = viewController
            return
        }

        viewController.snkNavigationBarDefaultStyle(backgroundColor: .accent, tintColor: .black)
        window?.rootViewController = navigationController
    }

    func showSettings() {
        let viewController = SNKSettingsViewController()
        viewController.coordinator = self

        navigationController?.pushViewController(viewController, animated: true)
    }

    func showLeaderboard() {
        let viewController = SNKLeaderboardViewController()
        viewController.coordinator = self

        navigationController?.pushViewController(viewController, animated: true)
    }

    func showAbout() {
        let viewController = SNKAboutViewController()
        viewController.coordinator = self

        navigationController?.pushViewController(viewController, animated: true)
    }
}
