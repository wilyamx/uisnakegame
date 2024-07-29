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
    typealias SNKGameState = SNKSnakeGameViewModel.SNKGameState

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
        view.distribution = .equalSpacing
        return view
    }()
    private lazy var scoreTextLabel: UILabel = {
        let view = UILabel()
        view.text = "SCORE: 0"
        view.textAlignment = .left
        view.font = .body2
        view.textColor = .black
        view.lineBreakMode = .byCharWrapping
        return view
    }()
    private lazy var snakeLengthTextLabel: UILabel = {
        let view = UILabel()
        view.text = "SNAKE LENGTH: 0"
        view.textAlignment = .left
        view.font = .body2
        view.textColor = .black
        view.lineBreakMode = .byCharWrapping
        return view
    }()
    private lazy var levelTextLabel: UILabel = {
        let view = UILabel()
        view.text = "STAGE: 1"
        view.textAlignment = .right
        view.font = .body2
        view.textColor = .black
        view.lineBreakMode = .byCharWrapping
        return view
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = tileColor
        return view
    }()

    private lazy var progressBarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()

    typealias SNKDirection = SNKSnakeGameViewModel.SNKDirection

    private let viewModel = SNKSnakeGameViewModel()

    private var game: SNKSnakeGame?
    private var progressBar: SNKTimerProgressBar?
    private var userSwipeCallback: ((SNKDirection) -> ())?

    private var tileColor: UIColor {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.TILE_COLOR }
        return UIColor(hexString: config.grid.color)
    }
    var foodColor: UIColor {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.FOOD_COLOR }
        return UIColor(hexString: config.foodColor)
    }
    var obstacleColor: UIColor {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.OBSTACLE_COLOR }
        return UIColor(hexString: config.obstacleColor)
    }
    var progressBarColor: UIColor {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.PROGRESS_BAR_COLOR }
        return UIColor(hexString: config.progressBarColor)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Skillful Snake"

        wsrLogger.info(message: "viewDidLoad")
        viewModel.state = .start
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    deinit {
        game?.stop()
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            guard let key = press.key else { continue }

            switch key.charactersIgnoringModifiers {
            case UIKeyCommand.inputLeftArrow: changeDirection(to: .left)
            case UIKeyCommand.inputRightArrow: changeDirection(to: .right)
            case UIKeyCommand.inputUpArrow: changeDirection(to: .up)
            case UIKeyCommand.inputDownArrow: changeDirection(to: .down)
            default: break
            }
        }

        super.pressesEnded(presses, with: event)
    }

    // MARK: - Setups

    override func setupNavigation() {
        navigationController?.isNavigationBarHidden = false

        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItems = [pausePlayButton, restartButton]
    }

    override func setupLayout() {
        addSubviews([
            containerView,
            progressBarContainerView,
            bottomStackView.addArrangedSubviews([
                scoreTextLabel,
                snakeLengthTextLabel,
                levelTextLabel
            ])
        ])
    }

    override func setupConstraints() {
        containerView.left == view.left
        containerView.right == view.right
        containerView.top == view.topMargin

        progressBarContainerView.left == containerView.left
        progressBarContainerView.right == containerView.right
        progressBarContainerView.bottom == containerView.bottom
        progressBarContainerView.height == SNKConstants.PROGRESS_BAR_HEIGHT

        bottomStackView.top == progressBarContainerView.bottom
        bottomStackView.left == view.left + 20
        bottomStackView.right == view.right - 20
        bottomStackView.bottom == view.bottomMargin
    }

    override func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }

                updateUI()

                switch state {

                case .start:
                    game?.restart()
                    initGame()

                case .play:
                    game?.start()
                    progressBar?.play()
                    progressBar?.start(maxDuration: SNKConstants.GAME_DURATION_IN_SECONDS)

                case .pause:
                    let state = game?.pause()
                    pausePlayButton.image = UIImage(systemName: state == .started ? "pause" : "play")

                    if state == .started { progressBar?.play() }
                    else { progressBar?.pause() }

                case .restart:
                    game?.restart()
                    initGame()

                case .stop:
                    game?.stop()

                case .stageComplete(let stage):
                    progressBar?.pause()
                    Task { [weak self] in
                        await self?.showGameStageCompleteAlert(stage: stage)
                    }

                case .gameOver(let score):
                    progressBar?.pause()
                    Task { [weak self] in
                        let actionValue = await self?.showGameOverAlert(score: score) ?? false
                        // play again
                        if actionValue { self?.viewModel.state = .restart }
                        // quit
                        else { self?.dismiss(animated: true) }
                    }

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
        viewModel.state = .restart
    }

    @objc private func pausePlayTheGame() {
        viewModel.state = .pause
    }
}

// MARK: - Alerts

extension SNKSnakeGameViewController {
    private func showGameStageAlert(level: Int) async {
        await WSRAsyncAlertController<Bool>(
            message: nil,
            title: "Stage \(level)"
        )
        .addButton(title: "Ok", returnValue: true)
        .register(in: self)
    }

    private func showGameOverAlert(score: Int) async -> Bool {
        return await WSRAsyncAlertController<Bool>(
            message: "You got \(score) point(s)!",
            title: "GAME OVER!"
        )
        .addButton(title: "PLAY AGAIN", isPreferred: true, returnValue: true)
        .addButton(title: "QUIT", returnValue: false)
        .register(in: self)
    }

    private func showGameStageCompleteAlert(stage: Int) async {
        await WSRAsyncAlertController(
            message: "COMPLETED!",
            title: "STAGE \(stage)"
        )
        .addButton(title: "CONTINUE", returnValue: false)
        .register(in: self)
    }
}

// MARK: - Gameplay

extension SNKSnakeGameViewController {
    func initGame() {
        wsrLogger.info(message: "--------------")
        wsrLogger.info(message: "initGame...")
        wsrLogger.info(message: "You play as << \(SNKConstants.shared.activeUser) >>")
        wsrLogger.info(message: "UIScreen: \(UIScreen.main.bounds)")

        view.layoutIfNeeded()

        // BUG: wrong height
        var frame = containerView.bounds
        frame.size.height = 695

        game = SNKSnakeGame(frame: frame, tileSize: SNKConstants.TILE_SIZE)

        progressBar = SNKTimerProgressBar(
            frame: CGRect(x: 0, y: 0, width: frame.width, height: SNKConstants.PROGRESS_BAR_HEIGHT),
            color: SNKConstants.PROGRESS_BAR_COLOR
        )

        containerView.addSubview(game!.view)
        progressBarContainerView.addSubview(progressBar!)

        // adding game actors

        guard let game = game else { fatalError("Game not available!") }

        game.makeGrid()

        if viewModel.showGrid { game.makeGridView() }

        game.placeObstacle(row: 5, column: 25, color: obstacleColor)
        game.placeObstacle(row: 6, column: 25, color: obstacleColor)
        game.placeObstacle(row: 7, column: 25, color: obstacleColor)
        game.placeObstacle(row: 8, column: 25, color: obstacleColor)
        game.placeObstacle(row: 9, column: 25, color: obstacleColor)

        game.placeObstacle(row: 15, column: 5, color: obstacleColor)
        game.placeObstacle(row: 15, column: 6, color: obstacleColor)
        game.placeObstacle(row: 15, column: 7, color: obstacleColor)
        game.placeObstacle(row: 15, column: 8, color: obstacleColor)

        game.placeObstacle(row: 25, column: 5, color: obstacleColor)
        game.placeObstacle(row: 25, column: 6, color: obstacleColor)
        game.placeObstacle(row: 25, column: 7, color: obstacleColor)
        game.placeObstacle(row: 25, column: 8, color: obstacleColor)

        game.placeObstacle(row: 32, column: 0, color: obstacleColor)
        game.placeObstacle(row: 33, column: 0, color: obstacleColor)
        game.placeObstacle(row: 34, column: 0, color: obstacleColor)
        game.placeObstacle(row: 35, column: 0, color: obstacleColor)

        game.placeObstacle(row: 39, column: 17, color: obstacleColor)
        game.placeObstacle(row: 39, column: 18, color: obstacleColor)
        game.placeObstacle(row: 39, column: 19, color: obstacleColor)
        game.placeObstacle(row: 39, column: 20, color: obstacleColor)

        //game.placeRandomObstacle(color: obstacleColor)

        game.placeRandomFood(color: foodColor)

        game.makeSnake(row: 1, column: 1)

        setupGameBindings()

        Task {
            await showGameStageAlert(level: viewModel.currentStage)
            viewModel.state = .play
        }
    }
    
    private func setupGameBindings() {
        guard let game = game else { return }
        guard let progressBar = progressBar else { return }

        game.$score
            .receive(on: DispatchQueue.main)
            .sink { [weak self] score in
                self?.scoreTextLabel.text = "SCORE: \(score)"
            }
            .store(in: &cancellables)

        game.$snakeLength
            .receive(on: DispatchQueue.main)
            .sink { [weak self] length in
                self?.snakeLengthTextLabel.text = "SNAKE LENGTH: \(length)"
            }
            .store(in: &cancellables)

        game.$alertState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let state else { return }
                switch state {
                case .stageComplete: self?.viewModel.state = .stageComplete(game.stage)
                case .newStage: break
                case .gameOver(let score): self?.viewModel.state = .gameOver(score)
                }
            }
            .store(in: &cancellables)

        progressBar.$durationComplete
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completed in
                guard completed else { return }
                self?.viewModel.state = .stop
                self?.checkForNextState()
            }
            .store(in: &cancellables)
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

        changeDirection(to: direction)
        userSwipeCallback?(direction)
    }

    private func changeDirection(to direction: SNKDirection) {
        game?.snake?.changeDirection(to: direction)
    }

    private func updateUI() {
        // update based on game status
        //restartButton.isEnabled = viewModel.state != SNKGameState.stop
        //pausePlayButton.isEnabled = viewModel.state != SNKGameState.stop
    }

    /// check next game state after game duration completed
    private func checkForNextState() {
        guard let game = game else { return }

        // gameover
        //viewModel.state = .gameOver(game.score)
        viewModel.state = .stageComplete(game.stage)
    }
}
