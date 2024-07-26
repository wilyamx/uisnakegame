//
//  SNKConstants.swift
//  UISnakeGame
//
//  Created by William Rena on 7/25/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

class SNKConstants {
    static var TILE_SIZE = 15.0 //15
    static var SPEED = 0.15
    static var GRIDLINES_COLOR = UIColor.white
    static var TILE_COLOR = UIColor.accentVariation4
    static var FOOD_COLOR = UIColor.red
    static var OBSTACLE_COLOR = UIColor.black

    static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?
            .windows
            .first(where: \.isKeyWindow)
    }

    static var safeAreaInsets: UIEdgeInsets {
        guard let keyWindow
        else { fatalError("There is no keyWindow. You must check source.") }
        return keyWindow.safeAreaInsets
    }

    static var statusBarHeight: CGFloat {
        keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }

    static var hasSafeAreaBottomMargin: Bool { SNKConstants.safeAreaInsets.bottom > 0 }
}
