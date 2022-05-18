//
//  CharacterListViewController+DataSource.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 18/05/2022.
//

import UIKit

extension CharacterListViewController {

    typealias CellProvider = UICollectionViewDiffableDataSource<Section, Character>.CellProvider
    typealias CellRegistration = UICollectionView.CellRegistration<CharacterListCell, Character>
    typealias CharacterListDiffableDataSource = UICollectionViewDiffableDataSource<Section, Character>
    typealias FooterRegistration = UICollectionView.SupplementaryRegistration<LoadingFooterView>
    typealias SupplementaryViewProvider = UICollectionViewDiffableDataSource<Section, Character>.SupplementaryViewProvider

    static func diffableDataSource(for collectionView: UICollectionView) -> CharacterListDiffableDataSource {
        let characterListCellRegistration = CellRegistration { cell, _, item in
            cell.configure(with: item)
        }
        let cellProvider: CellProvider = { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            switch Section(rawValue: indexPath.section) {
            case .characters:
                return collectionView.dequeueConfiguredReusableCell(using: characterListCellRegistration, for: indexPath, item: identifier)
            default:
                fatalError("This collection view only supports one section")
            }
        }
        let footerRegistration = FooterRegistration(elementKind: LoadingFooterView.elementKind) { (supplementaryView, _, _) in
            supplementaryView.activityIndicatorView.startAnimating()
        }
        let supplementaryViewProvider: SupplementaryViewProvider = { (collectionView, _, indexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
        }
        let dataSource = CharacterListDiffableDataSource(collectionView: collectionView, cellProvider: cellProvider)
        dataSource.supplementaryViewProvider = supplementaryViewProvider
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([Section.characters])
        dataSource.applySnapshotUsingReloadData(snapshot)
        return dataSource
    }
}
