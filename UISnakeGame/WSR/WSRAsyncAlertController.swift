//
//  WSRAsyncAlertController.swift
//  UISnakeGame
//
//  Created by William Rena on 7/28/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

class WSRAsyncAlertController<T> {
    private let alertController: UIAlertController
    private var continuation: CheckedContinuation<T, Never>?

    private let title: String?
    private let message: String?

    init(message: String? = nil, title: String? = nil,
         name: String? = nil, preferredStyle: UIAlertController.Style = .alert) {
        self.title = title
        self.message = message
        self.alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    }

    @discardableResult
    func addButton(
        title: String, style: UIAlertAction.Style = .default, isPreferred: Bool = false,
        isCancel: Bool = false, returnValue: T
    ) -> Self {
        let newAlertAction = UIAlertAction(title: title, style: style) { [weak self] action in
            guard let continuation = self?.continuation else { fatalError("You must use registerAsync.") }
            continuation.resume(returning: returnValue)
        }
        alertController.addAction(newAlertAction)
        if isPreferred { alertController.preferredAction = newAlertAction }
        return self
    }

    @discardableResult
    func register(in parentViewController: UIViewController) async -> T {
        await withCheckedContinuation { continuation in
            self.continuation = continuation
            DispatchQueue.main.async {
                parentViewController.present(self.alertController, animated: true)
            }
        }
    }
}
