//
//  SNKCollectionViewCell.swift
//  UISnakeGame
//
//  Created by William Rena on 7/23/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit

class SNKCollectionViewCell: UICollectionViewCell {
    //var colorStyle: ColorStyle = .text
    //var highlightColor: UIColor? = .secondaryAction.withAlphaComponent(0.3)

    class var identifier: String {
        let name = NSStringFromClass(self)
        let components = name.components(separatedBy: ".")
        return components.last ?? "Unknown" + "Identifier"
    }

    class func registerCell(to collectionView: UICollectionView) {
        collectionView.register(self, forCellWithReuseIdentifier: identifier)
    }

    class func dequeueCell(from collectionView: UICollectionView, for indexPath: IndexPath) -> Self {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: identifier, for: indexPath
        ) as? Self else {
            fatalError("Could not get cell object. identifier => \(identifier)")
        }
        return cell
    }
    
    override var reuseIdentifier: String? {
        SNKCollectionViewCell.identifier
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    deinit {

    }

    override func prepareForReuse() {
        
    }

    func setup() {
        //colorStyle = .text
        setupLayout()
        setupConstraints()
        setupBindings()
        setupActions()
    }

    func setupLayout() {}
    func setupConstraints() {}
    func setupBindings() {}
    func setupActions() {}
}
