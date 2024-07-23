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
        let viewController = SNKHomeViewController.instantiate()
        viewController.coordinator = self

        navigationController?.pushViewController(viewController, animated: false)

        guard let navigationController = navigationController
        else {
            window?.rootViewController = viewController
            return
        }

        viewController.snkNavigationBarDefaultStyle()
        window?.rootViewController = navigationController
    }
}
