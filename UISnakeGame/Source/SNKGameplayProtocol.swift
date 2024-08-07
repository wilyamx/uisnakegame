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
    typealias SNKGameProgressData = SNKSnakeGameViewModel.SNKGameProgressData

    var currentStage: Int { get set }
    var score: Int { get set }
    var snakeLength: Int { get set }
    var isLastStage: Bool { get set }

    var stages: [SNKStageData] { get }
    var duration: Int { get }
    var defaultSnakeLength: Int { get }
    var minimumSpeed: CGFloat { get }
    var minimumFoodCredit: Int { get }
    var isTimeBasedStage: Bool { get }

    func gridInfo(in containerFrame: CGRect) -> SNKGridInfo
    func grid(frame: CGRect, tileSize: CGFloat) -> SNKGrid
    func gridView(frame: CGRect, tileSize: CGFloat) -> SNKGridView

    func gameplayAlert(in viewController: UIViewController) async
    func welcomeStageAlert(in viewController: UIViewController) async
    func completedStageAlert(in viewController: UIViewController, score: Int) async -> String
    func gameOverStageAlert(in viewController: UIViewController, score: Int) async -> String

    func flexibleSnakeAlert(in viewController: UIViewController) async
    func invisibleSnakeAlert(in viewController: UIViewController) async
    func hardHeadedSnakeAlert(in viewController: UIViewController) async

    func hasMoreFoodAvailable(eatenFoodCount: Int) -> Bool
    func currentStageData() -> SNKStageData?
    func saveProgress()

    mutating func earnedNewPoints(stageScore: Int)
    mutating func nextStage()
    mutating func restoreProgress()
    mutating func restart()
}
