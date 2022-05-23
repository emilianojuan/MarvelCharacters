//
//  CharacterListViewController+DataSource.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 18/05/2022.
//

import UIKit

extension CharacterListViewController {

    typealias CellProvider = UICollectionViewDiffableDataSource<CharactersCollectionViewSection, CharacterListItem>.CellProvider
    typealias CellRegistration = UICollectionView.CellRegistration<CharacterListCell, CharacterListItem>
    typealias CharacterListDiffableDataSource = UICollectionViewDiffableDataSource<CharactersCollectionViewSection, CharacterListItem>
    typealias FooterRegistration = UICollectionView.SupplementaryRegistration<LoadingFooterView>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<TotalShowingHeaderView>
    typealias SupplementaryViewProvider = UICollectionViewDiffableDataSource<CharactersCollectionViewSection,
                                                                             CharacterListItem>.SupplementaryViewProvider
    typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<CharactersCollectionViewSection, CharacterListItem>

    var diffableDataSource: CharacterListDiffableDataSource {
        let characterListCellRegistration = CellRegistration { cell, _, item in
            cell.configure(with: item)
        }
        let cellProvider: CellProvider = { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            switch CharactersCollectionViewSection(rawValue: indexPath.section) {
            case .characters:
                return collectionView.dequeueConfiguredReusableCell(using: characterListCellRegistration, for: indexPath, item: identifier)
            default:
                fatalError("This collection view only supports one section")
            }
        }
        let headerRegistration = HeaderRegistration(elementKind: TotalShowingHeaderView.elementKind) { [weak self] (headerView, _, _) in
            headerView.showingTotalLabel = self?.showingTotalLabel
        }
        let footerRegistration = FooterRegistration(elementKind: LoadingFooterView.elementKind) { [weak self] (footerView, _, _) in
            footerView.activityIndicatorView = self?.activityIndicator
        }
        let supplementaryViewProvider: SupplementaryViewProvider = { (collectionView, elementKind, indexPath) in
            if elementKind == TotalShowingHeaderView.elementKind {
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            } else {
                return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
            }

        }
        let dataSource = CharacterListDiffableDataSource(collectionView: charactersCollectionView, cellProvider: cellProvider)
        dataSource.supplementaryViewProvider = supplementaryViewProvider
        var snapshot = NSDiffableDataSourceSnapshot<CharactersCollectionViewSection, CharacterListItem>()
        snapshot.appendSections([CharactersCollectionViewSection.characters])
        dataSource.applySnapshotUsingReloadData(snapshot)
        return dataSource
    }
}
