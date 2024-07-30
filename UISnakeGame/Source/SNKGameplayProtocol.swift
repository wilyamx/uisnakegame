//
//  SNKGameplayProtocol.swift
//  UISnakeGame
//
//  Created by William Rena on 7/30/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

protocol SNKGameplayProtocol {
    typealias SNKGridInfo = SNKGrid.SNKGridInfo

    var currentStage: Int { get set }
    var stages: [SNKStageData] { get }

    func grid(frame: CGRect, tileSize: CGFloat) -> SNKGrid
    func gridView(frame: CGRect, tileSize: CGFloat) -> SNKGridView
    func welcomeStageAlert(in viewController: UIViewController, stage: Int) async
    func completedStageAlert(in viewController: UIViewController, stage: Int) async
    mutating func nextStage() -> SNKStageData?
    func gridInfo(in containerFrame: CGRect) -> SNKGridInfo
}
