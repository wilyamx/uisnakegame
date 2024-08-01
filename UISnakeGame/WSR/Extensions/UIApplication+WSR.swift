//
//  UIApplication+WSR.swift
//  UISnakeGame
//
//  Created by William Rena on 8/1/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

extension UIApplication {
    static func getTopViewController(base: UIViewController? = rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopViewController(base: selected)
            }
        }

        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }

        return base
    }

    static var rootViewController:UIViewController?{
        return UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }?.rootViewController
    }
}
