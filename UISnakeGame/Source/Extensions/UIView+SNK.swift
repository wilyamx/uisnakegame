//
//  UIView+SNK.swift
//  UISnakeGame
//
//  Created by William Rena on 7/23/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit
import SuperEasyLayout

extension UIView {
    func setLayoutEqualTo(_ view: UIView, margins: UIEdgeInsets = .zero) {
        top == view.top + margins.top
        left == view.left + margins.left
        right == view.right - margins.right
        bottom == view.bottom - margins.bottom
    }

    func setLayoutEqualTo(
        _ view: UIView,
        leftMargin: CGFloat = 0,
        rightMargin: CGFloat = 0,
        topMargin: CGFloat = 0,
        bottomMargin: CGFloat = 0
    ) {
        top == view.top + topMargin
        left == view.left + leftMargin
        right == view.right - rightMargin
        bottom == view.bottom - bottomMargin
    }
}
