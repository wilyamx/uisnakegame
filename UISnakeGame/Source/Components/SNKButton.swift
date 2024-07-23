//
//  SNKButton.swift
//  UISnakeGame
//
//  Created by William Rena on 7/23/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

class SNKButton: UIButton {

    var font: UIFont = .preferredFont(forTextStyle: .body) { didSet {
        self.text = text
    } }

    var text: String {
        get { titleLabel?.attributedText?.string ?? "" }
        set {
            let attributedString = newValue.getAttributedString(with: font, color: colorStyle.textColor)
            setAttributedTitle(attributedString, for: state)
        }
    }

    var colorStyle: ColorStyle = .primary { didSet {
        guard let attributedString = titleLabel?.attributedText else { return }

        // background
        backgroundColor = colorStyle.backgroundColor

        // foreground
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttributedString
            .addAttribute(.foregroundColor,
                          value: colorStyle.textColor,
                          range: NSRange(location: 0, length: attributedString.string.count))
        setAttributedTitle(mutableAttributedString, for: state)
        tintColor = colorStyle.textColor
    } }

    var tapHandler: ((UIButton) -> Void)?
    var tapHandlerAsync: ((UIButton) async -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    convenience init(image: UIImage?) {
        let frame = CGRect(origin: CGPoint.zero, size: image?.size ?? CGSize.zero)
        self.init(frame: frame)
        setImage(image, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    deinit {

    }

    func setup() {
        colorStyle = .primary
        addTarget(self, action: #selector(touchUpInsideButton(_:)), for: .touchUpInside)
        isExclusiveTouch = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}


// MARK: - Actions

extension SNKButton {
    @objc func touchUpInsideButton(_: Any) {
        if let tapHandlerAsync {
            Task {
                await tapHandlerAsync(self)
            }
            return
        } else if let tapHandler {
            tapHandler(self)
        }
    }
}
