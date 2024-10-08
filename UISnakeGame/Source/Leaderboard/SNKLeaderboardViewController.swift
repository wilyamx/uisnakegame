//
//  SNKLeaderboardViewController.swift
//  UISnakeGame
//
//  Created by William Rena on 7/23/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit
import WSRUtils

class SNKLeaderboardViewController: SNKViewController {
    weak var coordinator: SNKHomeCoordinator?
    
    let viewModel = SNKLeaderboardViewModel()

    private typealias Section = SNKLeaderboardViewModel.Section
    private typealias Item = SNKLeaderboardViewModel.Item
    private typealias ItemInfo = SNKLeaderboardViewModel.ItemInfo
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    private var dataSource: DataSource?
    
    private lazy var layout: UICollectionViewCompositionalLayout = {
        UICollectionViewCompositionalLayout { [weak self] index, _ in
            guard let self, let sections = dataSource?.snapshot().sectionIdentifiers else { fatalError() }

            switch sections[index] {
            case .main: return getMainSectionLayout()
            }
        }
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundView = nil
        view.backgroundColor = .color5

        SNKLeaderboardCollectionViewCell.registerCell(to: view)
        return view
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Leaderboard"
        navigationController?.isNavigationBarHidden = false

        wsrLogger.info(message: "viewDidLoad")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false

        Task { await viewModel.load() }
    }

    // MARK: - Setups

    override func setupLayout() {
        addSubviews([
            collectionView
        ])
    }

    override func setupConstraints() {
        collectionView.setLayoutEqualTo(view)
    }

    override func setupBindings() {
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.apply(items)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Collection Layout

extension SNKLeaderboardViewController {
    private func getMainSectionLayout() -> NSCollectionLayoutSection {
        let unitSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(109))
        let item = NSCollectionLayoutItem(layoutSize: unitSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: unitSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        return section
    }
}

// MARK: - Set View Based on Data

extension SNKLeaderboardViewController {
    private func apply(_ items: [Section: [Item]]) {
        guard !items.isEmpty else { return }

        var snapshot = Snapshot()
        snapshot.appendSections(items.keys.toArray)

        for (section, subitems) in items {
            snapshot.appendItems(subitems, toSection: section)
        }

        if let dataSource {
            dataSource.apply(snapshot, animatingDifferences: true)
        } else {
            dataSource = DataSource(
                collectionView: collectionView,
                cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                    switch itemIdentifier {
                    case .scoreItem(let info): self?.getLeaderboardCell(at: indexPath, item: info)
                    }
                })

            if #available(iOS 15.0, *) {
                dataSource?.applySnapshotUsingReloadData(snapshot)
            } else {
                dataSource?.apply(snapshot)
            }
        }
    }

    private func getLeaderboardCell(at indexPath: IndexPath, item: ItemInfo) -> SNKLeaderboardCollectionViewCell {
        let cell = SNKLeaderboardCollectionViewCell.dequeueCell(from: collectionView, for: indexPath)
        cell.rank = "\(indexPath.row + 1)"
        cell.name = "\(item.name)"
        cell.score = "\(item.score)"
        cell.cellBackgroundColor = indexPath.row % 2 == 0 ? .color3 : .color4
        cell.showMedal = item.isCompletedAllLevels
        cell.highlight = item.name == SNKConstants.shared.activeUser
        return cell
    }
}
