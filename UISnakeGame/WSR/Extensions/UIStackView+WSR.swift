//
//  UIStackView+WSR.swift
//  UISnakeGame
//
//  Created by William Rena on 7/23/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

extension UIStackView {
    @discardableResult
    func addArrangedSubviews(_ views: [UIView]) -> UIStackView {
        views.forEach { addArrangedSubview($0) }
        return self
    }

    @discardableResult
    func removeArrangedSubviews(where handler: (() -> Bool)? = nil) -> UIStackView {
        arrangedSubviews.forEach { if handler?() ?? true { removeArrangedSubview($0) } }
        return self
    }
}
