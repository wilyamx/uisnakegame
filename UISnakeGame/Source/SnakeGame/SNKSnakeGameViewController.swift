//
//  SNKSnakeGameViewController.swift
//  UISnakeGame
//
//  Created by William Rena on 7/24/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

class SNKSnakeGameViewController: SNKViewController {

    private lazy var dismissButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: nil)
        view.tintColor = .white
        return view
    }()
    
    private lazy var restartButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(systemName: "gobackward"), style: .plain, target: nil, action: nil)
        view.tintColor = .white
        return view
    }()

    private lazy var pausePlayButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(systemName: "pause"), style: .plain, target: nil, action: nil)
        view.tintColor = .white
        return view
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Skillful Snake"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Setups

    override func setupNavigation() {
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItems = [pausePlayButton, restartButton]
    }

    override func setupActions() {
        dismissButton.target = self
        dismissButton.action = #selector(dismissTheGame)

        restartButton.target = self
        restartButton.action = #selector(restartTheGame)

        pausePlayButton.target = self
        pausePlayButton.action = #selector(pausePlayTheGame)
    }

    // MARK: - Handlers

    @objc private func dismissTheGame() {
        dismiss(animated: true)
    }

    @objc private func restartTheGame() {
        wsrLogger.info(message: "222")
    }

    @objc private func pausePlayTheGame() {
        wsrLogger.info(message: "333")
    }
}

// MARK: - Alerts

extension SNKSnakeGameViewController {
    private func showGameLevelAlert(level: Int) {
        // create the alert
        let alert = UIAlertController(
            title: "Level \(level)", message: nil, preferredStyle: UIAlertController.Style.alert
        )
        alert.view.tintColor = .accent

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        present(alert, animated: true, completion: nil)
    }

    private func showGameLevelCompleteAlert(level: Int) {
        // create the alert
        let alert = UIAlertController(
            title: "LEVEL \(level)", message: "COMPLETE!", preferredStyle: UIAlertController.Style.alert
        )
        alert.view.tintColor = .accent

        // add an action (button)
        alert.addAction(UIAlertAction(title: "CONTINUE", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        present(alert, animated: true, completion: nil)
    }

    private func showGameOverAlert(points: Int) {
        // create the alert
        let alert = UIAlertController(
            title: "GAME OVER!", message: "\(points) points", preferredStyle: UIAlertController.Style.alert
        )
        alert.view.tintColor = .accent

        // add an action (button)
        alert.addAction(UIAlertAction(title: "PLAY AGAIN", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "QUIT", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        present(alert, animated: true, completion: nil)
    }
}
