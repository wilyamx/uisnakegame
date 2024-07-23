//
//  UIFont+WSR.swift
//  UISnakeGame
//
//  Created by William Rena on 7/23/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

extension UIFont {
    /// Font size: 33, weight: Regular
    static var largeTitle: UIFont {
        .systemFont(ofSize: 33)
    }

    /// Font size: 27, weight: Regular
    static var title1: UIFont {
        .systemFont(ofSize: 27)
    }

    /// Font size: 21, weight: Regular
    static var title2: UIFont {
        .systemFont(ofSize: 21)
    }

    /// Font size: 19, weight: Regular
    static var title3: UIFont {
        .systemFont(ofSize: 19)
    }

    /// Font size: 19, weight: Semi bold
    static var headline: UIFont {
        .systemFont(ofSize: 19, weight: .semibold)
    }

    /// Font size: 16, weight: Semi bold
    static var body1: UIFont {
        .systemFont(ofSize: 16, weight: .semibold)
    }

    /// Font size: 16, weight: Regular
    static var body2: UIFont {
        .systemFont(ofSize: 16)
    }

    /// Font size: 15, weight: Regular
    static var callout: UIFont {
        .systemFont(ofSize: 15)
    }

    /// Font size: 14, weight: Semi bold
    static var subhead: UIFont {
        .systemFont(ofSize: 14, weight: .semibold)
    }

    /// Font size: 12, weight: Regular
    static var footnote: UIFont {
        .systemFont(ofSize: 12)
    }

    /// Font size: 11, weight: Regular
    static var caption: UIFont {
        .systemFont(ofSize: 11)
    }

    static var captionWithHiragino: UIFont {
        UIFont(name: "HiraginoSans-W3", size: 11)!
    }

    // MARK: - Exception

    /// Font size: 21, weight: Bold
    static var largeNumeral: UIFont {
        .systemFont(ofSize: 21, weight: .bold)
    }

    /// Font size: 14, weight: Regular
    static var middle1Numberal: UIFont {
        .systemFont(ofSize: 14)
    }

    /// Font size: 12, weight: Semi bold
    static var primaryFootnote: UIFont {
        .systemFont(ofSize: 12, weight: .semibold)
    }

    /// Font size: 11, weight: Semi bold
    static var primaryCaption: UIFont {
        .systemFont(ofSize: 11, weight: .semibold)
    }

    /// Font size: 10, weight: Regular
    static var smallNumeral: UIFont {
        .systemFont(ofSize: 10)
    }

    /// Font size: 9, weight: Regular
    static var smallLabel: UIFont {
        .systemFont(ofSize: 9)
    }

    /// Font size: 9, weight: Semi bold
    static var smallCaption: UIFont {
        .systemFont(ofSize: 9, weight: .semibold)
    }

    /// Font size: 10, weight: Semi bold
    static var smallTitle: UIFont {
        .systemFont(ofSize: 10, weight: .semibold)
    }
}
