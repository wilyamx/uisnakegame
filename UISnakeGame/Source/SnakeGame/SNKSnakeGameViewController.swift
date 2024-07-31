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
    typealias SNKGridItem = SNKStageData.SNKGridItem

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
        view.text = "SNAKE: 0"
        view.textAlignment = .left
        view.font = .body2
        view.textColor = .black
        view.lineBreakMode = .byCharWrapping
        return view
    }()
    private lazy var stageTextLabel: UILabel = {
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

    // configurations
    private var tileColor: UIColor {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.TILE_COLOR }
        return UIColor(hexString: config.grid.color)
    }
    private var foodColor: UIColor {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.FOOD_COLOR }
        return UIColor(hexString: config.foodColor)
    }
    private var obstacleColor: UIColor {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.OBSTACLE_COLOR }
        return UIColor(hexString: config.obstacleColor)
    }
    private var progressBarColor: UIColor {
        guard let config = SNKConstants.shared.gameConfig else { return SNKConstants.PROGRESS_BAR_COLOR }
        return UIColor(hexString: config.progressBarColor)
    }

    // sound effects
    private let stageWelcomeSoundPlayer = WSRSoundPlayer(sound: .stageWelcome, enabled: SNKConstants.shared.alertSound)
    private let stageCompleteSoundPlayer = WSRSoundPlayer(sound: .stageComplete, enabled: SNKConstants.shared.alertSound)
    private let bgSoundPlayer = WSRSoundPlayer(sound: .background, enabled: SNKConstants.shared.backgroundSound, numberOfLoops: -1)

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "-- \(SNKConstants.shared.activeUser) --"

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
        viewModel.state = .stop
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
                stageTextLabel
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
                    bgSoundPlayer.play()

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
                    bgSoundPlayer.stop()
                    game?.stop()

                case .newStageAlert:
                    bgSoundPlayer.stop()
                    stageWelcomeSoundPlayer.play()

                    Task { [weak self] in
                        guard let self else { return }
                        
                        await game?.gameplay.welcomeStageAlert(in: self)
                        viewModel.state = .play
                    }

                case .stageComplete(let stage):
                    guard let game = game, let progressBar else { return }

                    progressBar.pause()
                    game.stop()
                    game.gameplay.snakeLength = game.snakeLength
                    game.gameplay.earnedNewPoints(stageScore: game.score)
                    game.gameplay.nextStage()
                    viewModel.update(gameplay: game.gameplay)

                    bgSoundPlayer.stop()
                    stageCompleteSoundPlayer.play()

                    Task { [weak self] in
                        guard let self else { return }

                        let actionName = await game.gameplay.completedStageAlert(in: self, score: game.score)
                        // casual gameplay
                        if actionName == "Play Again" {
                            viewModel.state = .restart
                        }
                        // map based gameplay
                        else if actionName == "Next Stage" {
                            viewModel.state = .start
                        }
                    }

                case .gameOver(let score):
                    guard let game = game, let progressBar else { return }

                    bgSoundPlayer.stop()
                    progressBar.pause()

                    Task { [weak self] in
                        guard let self else { return }
                        
                        let actionName = await game.gameplay.gameOverStageAlert(in: self, score: game.score)
                        // play again
                        if actionName == "Play Again" {
                            viewModel.state = .restart
                        }
                        // quit
                        else if actionName == "Quit" {
                            dismiss(animated: true)
                        }
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

        wsrLogger.info(message: "[Gameplay] Current Stage: \(viewModel.gameplay.currentStage), Total Score: \(viewModel.gameplay.score)")
        let gridInfo = viewModel.gameplay.gridInfo(in: frame)

        game = SNKSnakeGame(
            frame: CGRect(x: 0, y: 0, width: gridInfo.area.width, height: gridInfo.area.height),
            tileSize: gridInfo.tileSize,
            gameplay: viewModel.gameplay
        )

        progressBar = SNKTimerProgressBar(
            frame: CGRect(x: 0, y: 0, width: frame.size.width, height: SNKConstants.PROGRESS_BAR_HEIGHT),
            color: SNKConstants.PROGRESS_BAR_COLOR
        )

        containerView.addSubview(game!.view)
        progressBarContainerView.addSubview(progressBar!)

        // adding game actors

        guard let game = game else { fatalError("Game not available!") }

        game.makeGrid()

        if SNKConstants.shared.displayGrid { game.makeGridView() }

        game.placeObstacles()
        //game.placeFoods()
        game.placeRandomFood()

        game.makeSnake(row: 1, column: 1, length: viewModel.gameplay.snakeLength)

        setupGameBindings()

        game.stage = viewModel.gameplay.currentStage
        game.snakeLength = viewModel.gameplay.snakeLength

        viewModel.state = .newStageAlert
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

        game.$stage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stage in
                self?.stageTextLabel.text = "STAGE: \(stage)"
            }
            .store(in: &cancellables)

        game.$snakeLength
            .receive(on: DispatchQueue.main)
            .sink { [weak self] length in
                self?.snakeLengthTextLabel.text = "SNAKE: \(length)"
            }
            .store(in: &cancellables)

        game.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .stageComplete: self?.viewModel.state = .stageComplete(game.stage)
                case .gameOver(let score): self?.viewModel.state = .gameOver(score)
                default: break
                }
            }
            .store(in: &cancellables)

        progressBar.$durationComplete
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completed in
                guard completed else { return }
                self?.viewModel.state = .stageComplete(game.stage)
            }
            .store(in: &cancellables)

        wsrLogger.info(message: "setupGameBindings")
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
        restartButton.isEnabled = viewModel.state != SNKGameState.stop
        pausePlayButton.isEnabled = viewModel.state != SNKGameState.stop
    }
}
