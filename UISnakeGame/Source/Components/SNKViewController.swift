//
//  SNKViewController.swift
//  UISnakeGame
//
//  Created by William Rena on 7/22/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit
import Combine

class SNKViewController: UIViewController {

    lazy var cancellables = Set<AnyCancellable>()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .mainBackground

        setupNavigation()
        setupLayout()
        setupConstraints()
        setupBindings()
        setupActions()
    }

    // MARK: - Setup Methods

    func setupNavigation() {}
    func setupLayout() {}
    func setupConstraints() {}
    func setupBindings() {}
    func setupActions() {}
}

// MARK: - Navigation Bar

extension SNKViewController {
    func snkNavigationBarDefaultStyle(backgroundColor: UIColor = .black, tintColor: UIColor = .white) {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = backgroundColor
            appearance.shadowColor = .clear

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance

            let titleAttribute = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
            appearance.titleTextAttributes = titleAttribute
        } else {
            let navigationBar = navigationController?.navigationBar
            navigationBar?.standardAppearance.backgroundColor = backgroundColor
            navigationBar?.standardAppearance.shadowColor = .clear
        }
        navigationController?.navigationBar.tintColor = tintColor
        navigationItem.backButtonTitle = ""
    }
}
