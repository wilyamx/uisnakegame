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

    private lazy var bottomStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 0
        return view
    }()
    private lazy var scoreTextLabel: UILabel = {
        let view = UILabel()
        view.text = "SCORE: 0"
        view.textAlignment = .left
        view.font = .title2
        view.textColor = .black
        view.lineBreakMode = .byCharWrapping
        return view
    }()
    private lazy var levelTextLabel: UILabel = {
        let view = UILabel()
        view.text = "LEVEL: 1"
        view.textAlignment = .right
        view.font = .title2
        view.textColor = .black
        view.lineBreakMode = .byCharWrapping
        return view
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = SNKConstants.TILE_COLOR
        return view
    }()

    typealias SNKDirection = SNKSnakeGameViewModel.SNKDirection

    let viewModel = SNKSnakeGameViewModel()

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
            containerView,
            bottomStackView.addArrangedSubviews([
                scoreTextLabel,
                levelTextLabel
            ])
        ])
    }

    override func setupConstraints() {
        containerView.left == view.left
        containerView.right == view.right
        containerView.top == view.topMargin

        bottomStackView.top == containerView.bottom
        bottomStackView.left == view.left + 20
        bottomStackView.right == view.right - 20
        bottomStackView.bottom == view.bottomMargin
    }

    override func setupBindings() {
        game?.$score
            .receive(on: DispatchQueue.main)
            .sink { [weak self] score in
                self?.scoreTextLabel.text = "SCORE: \(score)"
            }
            .store(in: &cancellables)

        game?.$alertState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let state else { return }
                switch state {
                case .levelComplete: break
                case .newLevel: break
                case .gameOver(let score): self?.showGameOverAlert(score: score)
                }
            }
            .store(in: &cancellables)
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

    private func showGameOverAlert(score: Int) {
        // create the alert
        let alert = UIAlertController(
            title: "GAME OVER!", message: "You got \(score) point(s)!", preferredStyle: UIAlertController.Style.alert
        )
        alert.view.tintColor = .accent

        // add an action (button)
        alert.addAction(UIAlertAction(title: "PLAY AGAIN", style: UIAlertAction.Style.cancel) { [weak self] action in
            self?.game?.restart()
            self?.initGame()
        })
        alert.addAction(UIAlertAction(title: "QUIT", style: UIAlertAction.Style.default) { [weak self] action in
            self?.dismiss(animated: true)
        })

        // show the alert
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Gameplay

extension SNKSnakeGameViewController {
    func initGame() {
        wsrLogger.info(message: "--------------")
        wsrLogger.info(message: "initGame...")
        wsrLogger.info(message: "UIScreen: \(UIScreen.main.bounds)")
        wsrLogger.info(message: "SafeAreaInset: \(SNKConstants.safeAreaInsets)")
        view.layoutIfNeeded()

        let snakeGame = SNKSnakeGame(frame: containerView.bounds, tileSize: SNKConstants.TILE_SIZE)
        game = snakeGame

        containerView.addSubview(snakeGame.view)

        // BUG: wrong height
        // adding game actors
        game?.makeGrid()
        game?.makeGridView()

        game?.placeObstacle(row: 5, column: 25)
        game?.placeObstacle(row: 6, column: 25)
        game?.placeObstacle(row: 7, column: 25)
        game?.placeObstacle(row: 8, column: 25)
        game?.placeObstacle(row: 9, column: 25)

        game?.placeObstacle(row: 15, column: 5)
        game?.placeObstacle(row: 15, column: 6)
        game?.placeObstacle(row: 15, column: 7)
        game?.placeObstacle(row: 15, column: 8)

        game?.placeObstacle(row: 25, column: 5)
        game?.placeObstacle(row: 25, column: 6)
        game?.placeObstacle(row: 25, column: 7)
        game?.placeObstacle(row: 25, column: 8)

        game?.placeObstacle(row: 32, column: 0)
        game?.placeObstacle(row: 33, column: 0)
        game?.placeObstacle(row: 34, column: 0)
        game?.placeObstacle(row: 35, column: 0)

        game?.placeObstacle(row: 39, column: 17)
        game?.placeObstacle(row: 39, column: 18)
        game?.placeObstacle(row: 39, column: 19)
        game?.placeObstacle(row: 39, column: 20)

        //game?.placeRandomObstacle(color: SNKConstants.OBSTACLE_COLOR)

        game?.placeRandomFood(color: SNKConstants.FOOD_COLOR)

        game?.makeSnake()

        setupBindings()
        updateUI()

        game?.start()
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
