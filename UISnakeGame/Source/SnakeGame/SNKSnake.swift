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
    typealias SNKGridInfo = SNKGrid.SNKGridInfo

    /// the view containing all body parts of the snake
    let view = UIView()

    var bodyParts: [SNKTileView] = []
    var stepSize: CGFloat = 0
    var gridInfo: SNKGridInfo

    private var previousFacingDirection: SNKDirection = .right

    init(frame: CGRect, size: CGFloat, location: CGPoint, gridInfo: SNKGridInfo) {
        self.gridInfo = gridInfo
        self.stepSize = size
        view.frame = frame

        // default right direction

        // [0] head
        let headFrame = CGRect(x: location.x, y: location.y, width: size, height: size)
        let head = SNKTileView(frame: headFrame, color: .black)

        // [1] body 1
        let body1Frame = CGRect(x: location.x - size * 1, y: location.y, width: size, height: size)
        let body1 = SNKTileView(frame: body1Frame, color: .lightGray)

        // [2] body 2
        let body2Frame = CGRect(x: location.x - size * 2, y: location.y, width: size, height: size)
        let body2 = SNKTileView(frame: body2Frame, color: .lightGray)

        // [3] tail
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

    private func getPartsLocation() -> [CGPoint] {
        var locations: [CGPoint] = []
        for part in bodyParts {
            locations.append(part.frame.origin)
        }
        return locations
    }

    // MARK: - Change Directions

    func changeDirection(to direction: SNKDirection) {
        guard direction != previousFacingDirection else { return }
        guard direction != previousFacingDirection.opposite else { return }
        //wsrLogger.info(message: "\(direction)")

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
        let locations = getPartsLocation()

        let x = bodyParts[0].frame.origin.x
        if x == 0 {
            bodyParts[0].frame.origin.x = gridInfo.rightMax - gridInfo.tileSize
        }
        else {
            bodyParts[0].frame.origin.x -= SNKConstants.TILE_SIZE
        }
        for i in 1..<bodyParts.count {
            bodyParts[i].frame.origin = locations[i - 1]
        }
    }

    private func moveRight() {
        let locations = getPartsLocation()

        let x = bodyParts[0].frame.origin.x
        if x == gridInfo.rightMax - gridInfo.tileSize {
            bodyParts[0].frame.origin.x = 0
        } else {
            bodyParts[0].frame.origin.x += SNKConstants.TILE_SIZE
        }
        for i in 1..<bodyParts.count {
            bodyParts[i].frame.origin = locations[i - 1]
        }
    }

    private func moveUp() {
        let locations = getPartsLocation()

        let y = bodyParts[0].frame.origin.y
        if y == 0 {
            bodyParts[0].frame.origin.y = gridInfo.bottomMax
        }
        else {
            bodyParts[0].frame.origin.y -= SNKConstants.TILE_SIZE
        }
        for i in 1..<bodyParts.count {
            bodyParts[i].frame.origin = locations[i - 1]
        }
    }

    private func moveDown() {
        let locations = getPartsLocation()

        let y = bodyParts[0].frame.origin.y
        if y == gridInfo.bottomMax - gridInfo.tileSize {
            bodyParts[0].frame.origin.y = 0
        } else {
            bodyParts[0].frame.origin.y += SNKConstants.TILE_SIZE
        }
        for i in 1..<bodyParts.count {
            bodyParts[i].frame.origin = locations[i - 1]
        }
    }

    // MARK: - Collision Detection

    func intersect(with location: CGPoint) -> Bool {
        getPartsLocation().contains(where: { $0.x == location.x && $0.y == location.y })
    }

    func intersect(with locations: [CGPoint]) -> CGPoint? {
        let headLocation = view.subviews[0].frame.origin
        return locations.first(where: { $0.x == headLocation.x && $0.y == headLocation.y })
    }
}
