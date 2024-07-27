//
//  WSRConstants.swift
//  UISnakeGame
//
//  Created by William Rena on 7/27/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

// MARK: - App specification infos

class WSRConstants {
    static var appVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""

    static var appName: String = (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? ""

    static var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?
            .windows
            .first(where: \.isKeyWindow)
    }

    static var safeAreaInsets: UIEdgeInsets {
        guard let keyWindow
        else { fatalError("There is no keyWindow. You must check source.") }
        return keyWindow.safeAreaInsets
    }

    static var statusBarHeight: CGFloat {
        keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }

    static var hasSafeAreaBottomMargin: Bool { WSRConstants.safeAreaInsets.bottom > 0 }
}
