//
//  UIFont+SNK.swift
//  UISnakeGame
//
//  Created by William S. Rena on 9/12/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

extension UIFont {
    /// Font size: 33, weight: Regular
    static var snk_largeTitle: UIFont {
        .systemFont(ofSize: 33)
    }

    /// Font size: 27, weight: Regular
    static var snk_title1: UIFont {
        .systemFont(ofSize: 27)
    }

    /// Font size: 21, weight: Regular
    static var snk_title2: UIFont {
        .systemFont(ofSize: 21)
    }

    /// Font size: 19, weight: Regular
    static var snk_title3: UIFont {
        .systemFont(ofSize: 19)
    }

    /// Font size: 19, weight: Semi bold
    static var snk_headline: UIFont {
        .systemFont(ofSize: 19, weight: .semibold)
    }

    /// Font size: 16, weight: Semi bold
    static var snk_body1: UIFont {
        .systemFont(ofSize: 16, weight: .semibold)
    }

    /// Font size: 16, weight: Regular
    static var snk_body2: UIFont {
        .systemFont(ofSize: 16)
    }

    /// Font size: 15, weight: Regular
    static var snk_callout: UIFont {
        .systemFont(ofSize: 15)
    }

    /// Font size: 14, weight: Semi bold
    static var snk_subhead: UIFont {
        .systemFont(ofSize: 14, weight: .semibold)
    }

    /// Font size: 12, weight: Regular
    static var snk_footnote: UIFont {
        .systemFont(ofSize: 12)
    }

    /// Font size: 11, weight: Regular
    static var snk_caption: UIFont {
        .systemFont(ofSize: 11)
    }

    static var snk_captionWithHiragino: UIFont {
        UIFont(name: "HiraginoSans-W3", size: 11)!
    }

    // MARK: - Exception

    /// Font size: 21, weight: Bold
    static var snk_largeNumeral: UIFont {
        .systemFont(ofSize: 21, weight: .bold)
    }

    /// Font size: 14, weight: Regular
    static var snk_middle1Numberal: UIFont {
        .systemFont(ofSize: 14)
    }

    /// Font size: 12, weight: Semi bold
    static var snk_primaryFootnote: UIFont {
        .systemFont(ofSize: 12, weight: .semibold)
    }

    /// Font size: 11, weight: Semi bold
    static var snk_primaryCaption: UIFont {
        .systemFont(ofSize: 11, weight: .semibold)
    }

    /// Font size: 10, weight: Regular
    static var snk_smallNumeral: UIFont {
        .systemFont(ofSize: 10)
    }

    /// Font size: 9, weight: Regular
    static var snk_smallLabel: UIFont {
        .systemFont(ofSize: 9)
    }

    /// Font size: 9, weight: Semi bold
    static var snk_smallCaption: UIFont {
        .systemFont(ofSize: 9, weight: .semibold)
    }

    /// Font size: 10, weight: Semi bold
    static var snk_smallTitle: UIFont {
        .systemFont(ofSize: 10, weight: .semibold)
    }
}
