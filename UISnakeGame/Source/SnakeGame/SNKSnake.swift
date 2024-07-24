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

        // default right direction

        // [0]
        let headFrame = CGRect(x: location.x, y: location.y, width: size, height: size)
        let head = SNKTileView(frame: headFrame, color: .black)

        // [1]
        let body1Frame = CGRect(x: location.x - size * 1, y: location.y, width: size, height: size)
        let body1 = SNKTileView(frame: body1Frame, color: .lightGray)

        // [2]
        let body2Frame = CGRect(x: location.x - size * 2, y: location.y, width: size, height: size)
        let body2 = SNKTileView(frame: body2Frame, color: .lightGray)

        // [3]
        let tailFrame = CGRect(x: location.x - size * 3, y: location.y, width: size, height: size)
        let tail = SNKTileView(frame: tailFrame, color: .gray)

        view.addSubview(head)
        view.addSubview(body1)
        view.addSubview(body2)
        view.addSubview(tail)

        bodyParts.append(head)
        bodyParts.append(body1)
        bodyParts.append(body2)
        bodyParts.append(tail)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeDirection(to direction: SNKDirection) {
        guard direction != previousFacingDirection else { return }
        wsrLogger.info(message: "\(direction)")

        previousFacingDirection = direction

        switch direction {
        case .left: moveLeft()
        case .right: moveRight()
        case .up: moveUp()
        case .down: moveDown()
        }
    }

    func move() {
        switch previousFacingDirection {
        case .left: moveLeft()
        case .right: moveRight()
        case .up: moveUp()
        case .down: moveDown()
        }
    }

    private func moveLeft() {
        var locations: [CGPoint] = []
        for part in bodyParts {
            locations.append(part.frame.origin)
        }

        bodyParts[0].frame.origin.x -= SNKSnakeGameViewController.TILE_SIZE
        for i in 1..<bodyParts.count {
            bodyParts[i].frame.origin = locations[i - 1]
        }
    }

    private func moveRight() {
        var locations: [CGPoint] = []
        for part in bodyParts {
            locations.append(part.frame.origin)
        }

        bodyParts[0].frame.origin.x += SNKSnakeGameViewController.TILE_SIZE
        for i in 1..<bodyParts.count {
            bodyParts[i].frame.origin = locations[i - 1]
        }
    }

    private func moveUp() {
        var locations: [CGPoint] = []
        for part in bodyParts {
            locations.append(part.frame.origin)
        }

        bodyParts[0].frame.origin.y -= SNKSnakeGameViewController.TILE_SIZE
        for i in 1..<bodyParts.count {
            bodyParts[i].frame.origin = locations[i - 1]
        }
    }

    private func moveDown() {
        var locations: [CGPoint] = []
        for part in bodyParts {
            locations.append(part.frame.origin)
        }

        bodyParts[0].frame.origin.y += SNKSnakeGameViewController.TILE_SIZE
        for i in 1..<bodyParts.count {
            bodyParts[i].frame.origin = locations[i - 1]
        }
    }
}
