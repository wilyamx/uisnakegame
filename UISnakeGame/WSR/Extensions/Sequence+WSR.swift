//
//  Sequence+WSR.swift
//  UISnakeGame
//
//  Created by William Rena on 7/23/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import Foundation

extension Sequence where Element: Hashable {
    var toArray: [Element] { Array(self) }
}
