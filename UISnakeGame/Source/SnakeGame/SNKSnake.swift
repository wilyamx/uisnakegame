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

    var previousFacingDirection: SNKDirection
    var facingDirection: SNKDirection

    var length: Int { return bodyParts.count }

    init(frame: CGRect, size: CGFloat, location: CGPoint,
         direction: SNKDirection, gridInfo: SNKGridInfo, length: Int = 4) {
        self.facingDirection = direction
        self.previousFacingDirection = direction
        self.gridInfo = gridInfo
        self.stepSize = size
        view.frame = frame

        // support right direction only for now
        if length == 1 { barbados(location: location, direction: direction, size: size) }
        else if length == 4 { python(location: location, direction: direction, size: size) }
        else { anaconda(location: location, direction: direction, size: size, length: length) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Parts

    private func barbados(location: CGPoint, direction: SNKDirection, size: CGFloat) {
        // [0] head
        let headFrame = CGRect(x: location.x, y: location.y, width: size, height: size)
        let head = SNKTileView(frame: headFrame, color: .accentVariation1)

        view.addSubview(head)
        bodyParts.append(head)
    }

    private func python(location: CGPoint, direction: SNKDirection, size: CGFloat) {
        // [0] head
        let headFrame = CGRect(x: location.x, y: location.y, width: size, height: size)
        let head = SNKTileView(frame: headFrame, color: .accentVariation1)

        // [1] body 1
        let body1Frame = CGRect(x: location.x - size * 1, y: location.y, width: size, height: size)
        let body1 = SNKTileView(frame: body1Frame, color: .accentVariation2)

        // [2] body 2
        let body2Frame = CGRect(x: location.x - size * 2, y: location.y, width: size, height: size)
        let body2 = SNKTileView(frame: body2Frame, color: .accentVariation2)

        // [3] tail
        let tailFrame = CGRect(x: location.x - size * 3, y: location.y, width: size, height: size)
        let tail = SNKTileView(frame: tailFrame, color: .accentVariation3)

        view.addSubview(head)
        view.addSubview(body1)
        view.addSubview(body2)
        view.addSubview(tail)

        bodyParts.append(head)
        bodyParts.append(body1)
        bodyParts.append(body2)
        bodyParts.append(tail)
    }

    private func anaconda(location: CGPoint, direction: SNKDirection, size: CGFloat, length: Int) {
        var parts: [SNKTileView] = []

        // [0] head
        let headFrame = CGRect(x: location.x, y: location.y, width: size, height: size)
        let head = SNKTileView(frame: headFrame, color: .accentVariation1)
        parts.append(head)

        // bodies
        for i in 0..<length - 2 {
            let bodyFrame = CGRect(x: location.x - size * CGFloat(i) + 1, y: location.y, width: size, height: size)
            let body = SNKTileView(frame: bodyFrame, color: .accentVariation2)
            parts.append(body)
        }

        // [last] tail
        let tailFrame = CGRect(x: location.x - size * CGFloat(parts.count), y: location.y, width: size, height: size)
        let tail = SNKTileView(frame: tailFrame, color: .accentVariation3)
        parts.append(tail)

        for part in parts {
            view.addSubview(part)
        }
        bodyParts = parts
    }

    func getLocations(excludedTheHead: Bool = false) -> [CGPoint] {
        var locations: [CGPoint] = []
        for (index, part) in bodyParts.enumerated() {
            if excludedTheHead && index == 0 { continue }
            locations.append(part.frame.origin)
        }
        return locations
    }

    // MARK: - Abilities

    func grow() -> Int {
        let locations = getLocations()
        move()

        guard let insertLocation = locations.last else { return 0 }

        let frame = CGRect(x: insertLocation.x, y: insertLocation.y, width: gridInfo.tileSize, height: gridInfo.tileSize)
        let body = SNKTileView(frame: frame, color: .accentVariation3)

        view.addSubview(body)
        bodyParts.append(body)

        let previousTailPart = bodyParts[bodyParts.count - 2]
        previousTailPart.fillColor = .accentVariation2
        previousTailPart.setNeedsDisplay()

        return bodyParts.count
    }

    // MARK: - Change Directions

    func changeDirection(to direction: SNKDirection) {
        // ignore same and opposite direction
        guard direction != previousFacingDirection else { return }
        guard direction != previousFacingDirection.opposite else { return }
        //wsrLogger.info(message: "\(direction)")

        // valid different direction
        facingDirection = direction
    }

    func move() {
        switch facingDirection {
        case .left: moveLeft()
        case .right: moveRight()
        case .up: moveUp()
        case .down: moveDown()
        }

        previousFacingDirection = facingDirection
    }

    private func moveLeft() {
        let locations = getLocations()

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
        let locations = getLocations()

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
        let locations = getLocations()

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
        let locations = getLocations()

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
        getLocations().contains(where: { $0.x == location.x && $0.y == location.y })
    }

    func intersect(with locations: [CGPoint]) -> CGPoint? {
        let headLocation = view.subviews[0].frame.origin
        return locations.first(where: { $0.x == headLocation.x && $0.y == headLocation.y })
    }

    func intersectWithItself() -> Bool {
        let headLocation = view.subviews[0].frame.origin
        let otherBodyLocations = getLocations(excludedTheHead: true)
        return otherBodyLocations.contains(where: { $0.x == headLocation.x && $0.y == headLocation.y })
    }
}
