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

    private lazy var newGameButton: SNKButton = {
        let view = SNKButton()

        view.setTitle("NEW GAME", for: .normal)
        view.colorStyle = .primary
        view.font = .callout
        view.text = "Lorem ipsum"

        view.layer.cornerRadius = 12
        return view
    }()

    weak var coordinator: SNKHomeCoordinator?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        print("[SNKHomeViewController] viewDidLoad")
    }

    // MARK: - Setup Methods

    override func setupLayout() {
        addSubviews([
            newGameButton
        ])
    }

    override func setupConstraints() {
        newGameButton.centerX == view.centerX
        newGameButton.centerY == view.centerY
        newGameButton.height == 44
    }
}
