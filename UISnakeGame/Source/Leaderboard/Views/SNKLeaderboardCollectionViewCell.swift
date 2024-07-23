//
//  SNKLeaderboardCollectionViewCell.swift
//  UISnakeGame
//
//  Created by William Rena on 7/23/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit
import SuperEasyLayout

class SNKLeaderboardCollectionViewCell: SNKCollectionViewCell {
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBackground
        return view
    }()

    private lazy var horizontalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 6
        view.alignment = .trailing
        return view
    }()
    private lazy var nameTextLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = .title1
        view.textColor = .black
        view.lineBreakMode = .byCharWrapping
        return view
    }()
    private lazy var medalImageView: UIImageView = {
        let image = UIImage(systemName: "medal")
        image?.applyingSymbolConfiguration(.init(font: .largeTitle, scale: .large))

        let view = UIImageView(image: image?.withRenderingMode(.alwaysTemplate))
        view.contentMode = .scaleAspectFit
        view.tintColor = .orange
        return view
    }()
    private lazy var scoreTextLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = .title1
        view.textColor = .black
        view.lineBreakMode = .byCharWrapping
        return view
    }()

    var name: String? {
        get { nameTextLabel.text }
        set { nameTextLabel.text = newValue }
    }
    var score: String? {
        get { scoreTextLabel.text }
        set { scoreTextLabel.text = newValue }
    }
    var cellBackgroundColor: UIColor? {
        get { backView.backgroundColor }
        set { backView.backgroundColor = newValue }
    }
    var showMedal: Bool = false { didSet {
        medalImageView.isHidden = !showMedal
    }}

    override func setupLayout() {
        contentView.addSubviews([
            backView.addSubviews([
                horizontalStackView.addArrangedSubviews([
                    nameTextLabel,
                    medalImageView,
                    scoreTextLabel
                ])
            ])
        ])
    }

    override func setupConstraints() {
        backView.setLayoutEqualTo(contentView)

        horizontalStackView.left == backView.left + 16
        horizontalStackView.right == backView.right - 16
        horizontalStackView.top == backView.top + 10
        horizontalStackView.bottom == backView.bottom - 10

        scoreTextLabel.width == 80

        medalImageView.width == 50
        medalImageView.height == 40
    }
}
