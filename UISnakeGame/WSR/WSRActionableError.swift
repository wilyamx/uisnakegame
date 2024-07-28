//
//  WSRActionableError.swift
//  UISnakeGame
//
//  Created by William Rena on 7/28/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

protocol WSRErrorActionType {
    var title: String { get }
    var isPreferred: Bool { get }
    var isCancel: Bool { get }
}

protocol WSRActionableError: Error, LocalizedError {
    associatedtype WSRCustomErrorActionType: WSRErrorActionType

    var alertName: String? { get }
    var title: String? { get }
    var alertActions: [WSRCustomErrorActionType] { get }
}

extension WSRActionableError {
    var alertName: String? { nil }

    @discardableResult @MainActor
    func showAlert(in parentViewController: UIViewController) async -> WSRCustomErrorActionType  {
        let alertController = WSRAsyncAlertController<WSRCustomErrorActionType>(
            message: errorDescription, title: title
        )
        for action in alertActions {
            alertController.addButton(
                title: action.title, isPreferred: action.isPreferred,
                isCancel: action.isCancel, returnValue: action
            )
        }
        return await alertController.register(in: parentViewController)
    }
}
