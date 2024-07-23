//
//  String+WSR.swift
//  UISnakeGame
//
//  Created by William Rena on 7/23/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

extension String {
    func getAttributedString(with font: UIFont,
                             color: UIColor? = .darkText,
                             attributes: [NSAttributedString.Key: Any]? = nil) -> NSMutableAttributedString {
        var attr: [NSAttributedString.Key: Any] = [.font: font]
        if let color {
            attr[.foregroundColor] = color
        }
        if let attributes {
            attr = attr.merging(attributes, uniquingKeysWith: { value1, _ -> Any in
                value1
            })
        }

        let attributedString = NSMutableAttributedString(string: self)

        // attributedのNSRangeのNSStringはutf-16がベースになっている。
        // 通常は指定しなくても問題ないが、絵文字を含むケースでは長さを指定しないと文字化けの原因になる。
        attributedString.addAttributes(attr, range: NSRange(location: 0, length: utf16.count))

        return attributedString
    }
}
