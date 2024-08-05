//
//  SNKImageTileView.swift
//  UISnakeGame
//
//  Created by William Rena on 8/4/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

class SNKImageTileView: SNKTileView {

    enum SNKImageTileType: Equatable {
        case obstacle
        case food
        case wave
        case pill

        private var foodColor: UIColor {
            guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.FOOD_COLOR }
            return UIColor(hexString: config.foodColor)
        }
        private var obstacleColor: UIColor {
            guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.OBSTACLE_COLOR }
            return UIColor(hexString: config.obstacleColor)
        }

        var systemName: String {
            switch self {
            case .obstacle: "light.panel.fill"
            case .food: "rotate.3d.fill"
            case .wave: "water.waves"
            case .pill: "pill.fill"
            }
        }

        var color: UIColor {
            switch self {
            case .obstacle: obstacleColor
            case .food: foodColor
            case .wave: .white
            case .pill: .white
            }
        }
    }

    var imageView: UIImageView

    var type: SNKImageTileType

    init(frame: CGRect, type: SNKImageTileType = .food) {
        self.type = type

        self.imageView = UIImageView(image: UIImage(systemName: type.systemName)?.withRenderingMode(.alwaysTemplate))
        self.imageView.contentMode = .scaleToFill
        self.imageView.tintColor = type.color
        self.imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)

        super.init(frame: frame, color: type.color)
        addSubview(self.imageView)

        fillColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

