//
//  SNKStyles.swift
//  UISnakeGame
//
//  Created by William Rena on 7/23/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

enum ColorStyle: Hashable {
    case primary
    case secondary

    var backgroundColor: UIColor {
        switch self {
        case .primary: .color1
        case .secondary: .red
        }
    }

    var disabledBackgroundColor: UIColor {
        switch self {
        case .primary, .secondary: .accentVariation4
        }
    }

    var textColor: UIColor {
        switch self {
        case .primary: .white
        case .secondary: .white
        }
    }

    var disabledTextColor: UIColor {
        switch self {
        case .primary, .secondary: .white
        }
    }
}
