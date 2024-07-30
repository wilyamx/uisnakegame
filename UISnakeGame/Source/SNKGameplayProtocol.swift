//
//  SNKGameplayProtocol.swift
//  UISnakeGame
//
//  Created by William Rena on 7/30/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

protocol SNKGameplayProtocol {
    var tileSize: CGFloat { get }
    
    func grid(frame: CGRect, tileSize: CGFloat) -> SNKGrid
    func gridView(frame: CGRect, tileSize: CGFloat) -> SNKGridView
    func welcomeStageAlert(in viewController: UIViewController, level: Int) async
}
