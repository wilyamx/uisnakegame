//
//  SNKSnakeGameViewController.swift
//  UISnakeGame
//
//  Created by William Rena on 7/24/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit
import SuperEasyLayout

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

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        return view
    }()

    typealias SNKDirection = SNKSnakeGameViewModel.SNKDirection

    let viewModel = SNKSnakeGameViewModel()

    static var TILE_SIZE = 20.0

    public var game: SNKSnakeGame?
    public var userSwipeCallback: ((SNKDirection) -> ())?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Skillful Snake"

        wsrLogger.info(message: "viewDidLoad")
        initGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        game?.start()
    }

    deinit {
        game?.stop()
    }
    
    // MARK: - Setups

    override func setupNavigation() {
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItems = [pausePlayButton, restartButton]
    }

    override func setupLayout() {
        addSubviews([
            containerView
        ])
    }

    override func setupConstraints() {
        containerView.left == view.left
        containerView.right == view.right
        containerView.top == view.topMargin
        containerView.bottom == view.bottomMargin
    }

    override func setupActions() {
        dismissButton.target = self
        dismissButton.action = #selector(dismissTheGame)

        restartButton.target = self
        restartButton.action = #selector(restartTheGame)

        pausePlayButton.target = self
        pausePlayButton.action = #selector(pausePlayTheGame)

        addSwipeGestures()
    }

    // MARK: - Handlers

    @objc private func dismissTheGame() {
        dismiss(animated: true)
    }

    @objc private func restartTheGame() {
        game?.restart()

        initGame()
    }

    @objc private func pausePlayTheGame() {
        let state = game?.pause()
        pausePlayButton.image = UIImage(systemName: state == .started ? "pause" : "play")
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

// MARK: - Gameplay

extension SNKSnakeGameViewController {
    func initGame() {
        wsrLogger.info(message: "--------------")
        wsrLogger.info(message: "initGame...")
        view.layoutIfNeeded()

        let snakeGame = SNKSnakeGame(frame: containerView.frame, tileSize: SNKSnakeGameViewController.TILE_SIZE)
        game = snakeGame

        containerView.addSubview(snakeGame.view)

        // BUG: wrong height
        // adding game components
        game?.makeGrid(frame: containerView.frame, tileSize: SNKSnakeGameViewController.TILE_SIZE)
        game?.makeGridView(frame: containerView.frame, tileSize: SNKSnakeGameViewController.TILE_SIZE)
        game?.makeSnake(frame: containerView.frame, tileSize: SNKSnakeGameViewController.TILE_SIZE)
        game?.placeRandomFood(color: .red)

        updateUI()
    }
    
    private func addSwipeGestures() {
        addSwipeGestureRecognizer(direction: .left)
        addSwipeGestureRecognizer(direction: .right)
        addSwipeGestureRecognizer(direction: .up)
        addSwipeGestureRecognizer(direction: .down)
    }

    private func addSwipeGestureRecognizer(direction: UISwipeGestureRecognizer.Direction) {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizer.direction = direction
        self.view.addGestureRecognizer(swipeGestureRecognizer)
    }

    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        let direction = SNKDirection(sender.direction)
        //wsrLogger.info(message: "\(direction)")

        game?.snake?.changeDirection(to: direction)
        userSwipeCallback?(direction)
    }

    // updates the collect coin label and the highscore label
    private func updateUI() {

    }
}
