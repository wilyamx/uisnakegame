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
        case .primary: UIColor(hexString: "#649D49")
        case .secondary: .red
        }
    }

    var disabledBackgroundColor: UIColor {
        switch self {
        case .primary, .secondary: .black
        }
    }

    var textColor: UIColor {
        switch self {
        case .primary: .black
        case .secondary: .white
        }
    }

    var disabledTextColor: UIColor {
        switch self {
        case .primary, .secondary: .white
        }
    }
}
