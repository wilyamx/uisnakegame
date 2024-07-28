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
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()

    private lazy var horizontalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 6
        view.alignment = .trailing
        return view
    }()
    private lazy var numberContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .contrast
        return view
    }()
    private lazy var rankTextLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .headline
        view.textColor = .white
        view.lineBreakMode = .byCharWrapping
        return view
    }()
    private lazy var nameTextLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = .title3
        view.textColor = .black
        view.lineBreakMode = .byCharWrapping
        return view
    }()
    private lazy var medalImageView: UIImageView = {
        let image = UIImage(systemName: "medal.fill")
        image?.applyingSymbolConfiguration(.init(font: .largeTitle, scale: .large))

        let view = UIImageView(image: image?.withRenderingMode(.alwaysTemplate))
        view.contentMode = .scaleAspectFit
        view.tintColor = .orange

        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 1.0
        view.layer.shadowOffset = .zero
        view.layer.masksToBounds = false
        return view
    }()
    private lazy var scoreTextLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = .headline
        view.textColor = .contrast
        view.lineBreakMode = .byCharWrapping
        return view
    }()

    var rank: String? {
        get { rankTextLabel.text }
        set { rankTextLabel.text = newValue }
    }
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
                    numberContainer.addSubviews([
                        rankTextLabel
                    ]),
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

        numberContainer.width == 30
        numberContainer.height == 30
        numberContainer.centerY == horizontalStackView.centerY

        rankTextLabel.centerX == numberContainer.centerX
        rankTextLabel.centerY == numberContainer.centerY

        nameTextLabel.centerY == horizontalStackView.centerY

        scoreTextLabel.width == 80
        scoreTextLabel.centerY == horizontalStackView.centerY

        medalImageView.width == 30
        medalImageView.height == 50
        medalImageView.centerY == horizontalStackView.centerY
    }
}
