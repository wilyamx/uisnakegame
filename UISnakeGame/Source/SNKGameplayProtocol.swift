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
    var score: Int { get set }
    var snakeLength: Int { get set }
    var stages: [SNKStageData] { get }

    func gridInfo(in containerFrame: CGRect) -> SNKGridInfo
    func grid(frame: CGRect, tileSize: CGFloat) -> SNKGrid
    func gridView(frame: CGRect, tileSize: CGFloat) -> SNKGridView

    func welcomeStageAlert(in viewController: UIViewController) async -> String
    func completedStageAlert(in viewController: UIViewController, score: Int) async -> String
    func gameOverStageAlert(in viewController: UIViewController, score: Int) async -> String

    mutating func nextStage()
    mutating func currentStageData() -> SNKStageData?

}
