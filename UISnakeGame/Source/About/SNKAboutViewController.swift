//
//  SNKAboutViewController.swift
//  UISnakeGame
//
//  Created by William Rena on 7/23/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit
import SuperEasyLayout
import WebKit
import WSRUtils

class SNKAboutViewController: SNKViewController {
    weak var coordinator: SNKHomeCoordinator?

    private let viewModel = SNKAboutViewModel()

    private lazy var webKitView = WKWebView()

    // MARK: - Setups

    override func setupLayout() {
        addSubviews([
            webKitView
        ])
    }

    override func setupConstraints() {
        webKitView.left == view.left + 20
        webKitView.right == view.right - 20
        webKitView.top == view.topMargin + 20
        webKitView.bottom == view.bottomMargin - 20
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About"
        navigationController?.isNavigationBarHidden = false

        loadContentFromResource()

        wsrLogger.info(message: "viewDidLoad")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Public Methods

    func loadContentFromResource() {
        if let htmlPath = Bundle.main.path(forResource: "about", ofType: "html") {
            do {
                let contents = try String(contentsOfFile: htmlPath, encoding: .utf8)
                let baseUrl = URL(fileURLWithPath: htmlPath)
                webKitView.loadHTMLString(contents, baseURL: baseUrl)

                view.addSubview(webKitView)
            } catch {
                print("\(error)")
            }
        }
    }
}
