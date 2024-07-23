//
//  SNKHomeViewController.swift
//  UISnakeGame
//
//  Created by William Rena on 7/22/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit
import SuperEasyLayout

class SNKHomeViewController: SNKViewController, WSRStoryboarded {

    private lazy var titleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        return view
    }()
    private lazy var skillfulTextLabel: UILabel = {
        let view = UILabel()
        view.text = "SKILLFUL"
        view.textAlignment = .center
        view.font = .largeTitle
        view.textColor = .red
        view.lineBreakMode = .byCharWrapping
        return view
    }()
    private lazy var snakeTextLabel: UILabel = {
        let view = UILabel()
        view.text = "SNAKE"
        view.textAlignment = .center
        view.font = .title1
        view.textColor = .black
        view.lineBreakMode = .byCharWrapping
        return view
    }()

    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 6
        return view
    }()
    private lazy var newGameButton: SNKButton = {
        let view = SNKButton()
        view.text = "NEW GAME"
        view.colorStyle = .primary
        view.font = .title3
        view.isUserInteractionEnabled = true
        return view
    }()
    private lazy var playButton: SNKButton = {
        let view = SNKButton()
        view.text = "PLAY"
        view.colorStyle = .primary
        view.font = .title3
        return view
    }()
    private lazy var settingsButton: SNKButton = {
        let view = SNKButton()
        view.text = "SETTINGS"
        view.colorStyle = .primary
        view.font = .title3
        return view
    }()
    private lazy var leaderboardButton: SNKButton = {
        let view = SNKButton()
        view.text = "LEADERBOARD"
        view.colorStyle = .primary
        view.font = .title3
        return view
    }()
    private lazy var aboutButton: SNKButton = {
        let view = SNKButton()
        view.text = "ABOUT"
        view.colorStyle = .primary
        view.font = .title3
        return view
    }()

    private lazy var developerTextLabel: UILabel = {
        let view = UILabel()
        view.text = "Developed by: WSR"
        view.textAlignment = .center
        view.font = .callout
        view.textColor = .gray
        view.lineBreakMode = .byCharWrapping
        return view
    }()

    weak var coordinator: SNKHomeCoordinator?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        navigationController?.isNavigationBarHidden = true

        wsrLogger.info(message: "viewDidLoad")
    }

    // MARK: - Setup Methods

    override func setupLayout() {
        addSubviews([
            titleStackView.addArrangedSubviews([
                skillfulTextLabel,
                snakeTextLabel
            ]),
            verticalStackView.addArrangedSubviews([
                newGameButton,
                playButton,
                settingsButton,
                leaderboardButton,
                aboutButton
            ]),
            developerTextLabel
        ])
    }

    override func setupActions() {
        newGameButton.tapHandler = { _ in
            wsrLogger.info(message: "newGameButton")
        }
        playButton.tapHandler = { _ in
            wsrLogger.info(message: "playButton")
        }
        settingsButton.tapHandler = { _ in
            wsrLogger.info(message: "settingsButton")
        }
        leaderboardButton.tapHandler = { _ in
            wsrLogger.info(message: "leaderboardButton")
        }
        aboutButton.tapHandler = { _ in
            wsrLogger.info(message: "aboutButton")
        }
    }

    override func setupConstraints() {
        titleStackView.left == view.left + 40
        titleStackView.right == view.right - 40
        titleStackView.top == view.topMargin + UIScreen.main.bounds.height * 0.2

        verticalStackView.left == view.left + 40
        verticalStackView.right == view.right - 40

        newGameButton.height == 44
        playButton.height == 44
        settingsButton.height == 44
        leaderboardButton.height == 44
        aboutButton.height == 44

        developerTextLabel.left == view.left + 40
        developerTextLabel.right == view.right - 40
        developerTextLabel.top == verticalStackView.bottom + 40
        developerTextLabel.bottom == view.bottomMargin
    }
}
