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
    private typealias ItemInfo = SNKLeaderboardViewModel.ItemInfo

    private let viewModel = SNKHomeViewModel()

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

        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 1.0
        view.layer.shadowOffset = .zero
        view.layer.masksToBounds = false
        return view
    }()
    private lazy var snakeTextLabel: UILabel = {
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 50)]
        as [NSAttributedString.Key : Any]

        let view = UILabel()
        view.textAlignment = .center
        view.lineBreakMode = .byCharWrapping
        view.attributedText = NSMutableAttributedString(string: "S-N-A-K-E", attributes: strokeTextAttributes)

        return view
    }()
    private lazy var medalImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "green-snake-crawl"))
        view.contentMode = .scaleAspectFit
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
        view.layer.cornerRadius = 20
        return view
    }()
    private lazy var playButton: SNKButton = {
        let view = SNKButton()
        view.text = SNKConstants.shared.hasActiveUser ? "PLAY" : "CONTINUE"
        view.colorStyle = .primary
        view.font = .title3
        view.layer.cornerRadius = 20
        return view
    }()
    private lazy var settingsButton: SNKButton = {
        let view = SNKButton()
        view.text = "SETTINGS"
        view.colorStyle = .primary
        view.font = .title3
        view.layer.cornerRadius = 20
        return view
    }()
    private lazy var leaderboardButton: SNKButton = {
        let view = SNKButton()
        view.text = "LEADERBOARD"
        view.colorStyle = .primary
        view.font = .title3
        view.layer.cornerRadius = 20
        return view
    }()
    private lazy var aboutButton: SNKButton = {
        let view = SNKButton()
        view.text = "ABOUT"
        view.colorStyle = .primary
        view.font = .title3
        view.layer.cornerRadius = 20
        return view
    }()

    private lazy var developerTextLabel: UILabel = {
        let view = UILabel()
        view.text = "Developed by: William S. Reña"
        view.textAlignment = .center
        view.font = .footnote
        view.textColor = .contrast
        view.lineBreakMode = .byCharWrapping
        return view
    }()

    weak var coordinator: SNKHomeCoordinator?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"

        Task {
            do {
                try await viewModel.loadGameConfiguration(from: SNKConstants.DEFAULT_GAME_CONFIG_FILE)
                await viewModel.applyDummyLeaderboard()
            } catch {
                if let error = error as? WSRFileLoaderError {
                    Task { await error.showAlert(in: self) }
                }
            }
        }

        wsrLogger.info(message: "viewDidLoad")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true

        updateUI()
    }

    // MARK: - Setups

    override func setupNavigation() {
        navigationController?.isNavigationBarHidden = true
    }

    override func setupLayout() {
        addSubviews([
            medalImageView,
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

        setGradientBackground()
    }

    override func setupActions() {
        newGameButton.tapHandler = { [weak self] _ in
            self?.showNewUserAlert()
        }
        playButton.tapHandler = { [weak self] _ in
            guard let self else { return }
            coordinator?.playTheGame(on: self, configuration: viewModel.configuration)
        }
        settingsButton.tapHandler = { [weak self] _ in
            self?.coordinator?.showSettings()
        }
        leaderboardButton.tapHandler = { [weak self] _ in
            self?.coordinator?.showLeaderboard()
        }
        aboutButton.tapHandler = { [weak self] _ in
            self?.coordinator?.showAbout()
        }
    }

    override func setupConstraints() {
        titleStackView.left == view.left + 40
        titleStackView.right == view.right - 40
        titleStackView.top == view.topMargin + UIScreen.main.bounds.height * 0.2

        medalImageView.centerX == titleStackView.centerX
        medalImageView.centerY == titleStackView.centerY
        medalImageView.width == 300
        medalImageView.height == 300

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

    // MARK: - Private Methods

    private func showNewUserAlert() {
        let alert = UIAlertController(title: "NEW GAME PROFILE", message: nil, preferredStyle: .alert)
        alert.view.tintColor = .accent
        alert.addTextField { textField in
            textField.placeholder = "Your name"
        }

        let submitAction = UIAlertAction(title: "OK", style: .default) { [self, unowned alert] _ in
            // at least 3 characters
            guard let name = alert.textFields![0].text, !name.isEmpty else { return }

            do {
                try viewModel.newUser(name: name)
            } catch  {
                guard let error = error as? SNKGameError else { return }
                Task {
                    await error.showAlert(in: self)
                }
            }

            self.updateUI()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(submitAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    private func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.accent.cgColor,
            UIColor.init(hexString: "#A5D721").cgColor,
            UIColor.init(hexString: "#EEFFBA").cgColor,
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = self.view.bounds

        self.view.layer.insertSublayer(gradientLayer, at:0)
    }

    private func updateUI() {
        playButton.text = SNKConstants.shared.activeUser.count < 3 ? "PLAY" : "CONTINUE"
        playButton.isEnabled = SNKConstants.shared.activeUser.count >= 3
        playButton.isHidden = !SNKConstants.shared.hasActiveUser
    }
}
