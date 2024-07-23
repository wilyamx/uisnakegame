//
//  SNKButton.swift
//  UISnakeGame
//
//  Created by William Rena on 7/23/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

class SNKButton: UIButton {

    var font: UIFont = .preferredFont(forTextStyle: .body) { didSet {
        self.text = text
    } }

    var text: String {
        get { titleLabel?.attributedText?.string ?? "" }
        set {
            let attributedString = newValue.getAttributedString(with: font, color: colorStyle.textColor)
            setAttributedTitle(attributedString, for: state)
        }
    }

//    var titleColors: [UIControl.State: UIColor?] = [:] {
//        didSet {
//            titleColors.forEach { state, color in
//                guard let attributedString = attributedTitle(for: state) else { return }
//                guard let color else { return }
//                let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
//                mutableAttributedString
//                    .addAttribute(.foregroundColor,
//                                  value: color,
//                                  range: NSRange(location: 0, length: attributedString.string.count))
//                setAttributedTitle(mutableAttributedString, for: state)
//            }
//        }
//    }
//
//    var backgroundColors: [UIControl.State: UIColor?] = [
//        UIControl.State.normal: .clear,
//        UIControl.State.disabled: .clear
//    ] {
//        didSet {
//            if let color = backgroundColors[state] {
//                backgroundColor = color
//            }
//        }
//    }

    var colorStyle: ColorStyle = .primary { didSet {
        guard let attributedString = titleLabel?.attributedText else { return }

        // background
        backgroundColor = colorStyle.backgroundColor

        // foreground
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttributedString
            .addAttribute(.foregroundColor,
                          value: colorStyle.textColor,
                          range: NSRange(location: 0, length: attributedString.string.count))
        setAttributedTitle(mutableAttributedString, for: state)
        tintColor = colorStyle.textColor
    } }

}
