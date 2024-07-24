//
//  SNKSnake.swift
//  UISnakeGame
//
//  Created by William Rena on 7/24/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

final class SNKSnake {
    typealias SNKDirection = SNKSnakeGameViewModel.SNKDirection

    /// the view containing all body parts of the snake
    let view = UIView()

    var bodyParts: [SNKTileView] = []

    private var previousFacingDirection: SNKDirection = .right

    init(frame: CGRect, size: CGFloat, location: CGPoint) {
        view.frame = frame

        let bodyFrame = CGRect(x: location.x, y: location.y, width: size, height: size)
        let head = SNKTileView(frame: bodyFrame, color: .black)

        view.addSubview(head)

        bodyParts.append(head)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeDirection(to direction: SNKDirection) {
        switch direction {
        case .left: moveLeft()
        case .right: moveRight()
        case .up: moveUp()
        case .down: moveDown()
        }
    }

    private func moveLeft() {
        var updatedBodyParts: [SNKTileView] = []


        //bodyParts[0].location = CGPoint()
    }

    private func moveRight() {

    }

    private func moveUp() {

    }

    private func moveDown() {

    }
}
