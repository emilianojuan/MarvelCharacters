//
//  CharacterListViewController+Layout.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 18/05/2022.
//

import UIKit

enum CharactersCollectionViewSection: Int {

    enum Constants {
        static let fullFractional: CGFloat = 1.0
        static let columnsMultiplier = 3
        static let interItemSpacing: CGFloat = 1.0
        static let interGroupSpacing: CGFloat = 1.0
        static let sectionContentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0,
                                                                                           leading: 20,
                                                                                           bottom: 20,
                                                                                           trailing: 20)
        static let compactFooterSize: CGFloat = 44.0
        static let regularFooterSize: CGFloat = 60.0
    }

    case characters

    func layout(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constants.fullFractional),
                                              heightDimension: .fractionalHeight(Constants.fullFractional))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let columnCount = layoutEnvironment.traitCollection.horizontalSizeClass.rawValue * Constants.columnsMultiplier
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constants.fullFractional),
                                               heightDimension: .fractionalWidth(CGFloat(Constants.fullFractional/CGFloat(columnCount))))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columnCount)
        group.interItemSpacing = .fixed(Constants.interItemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.interGroupSpacing
        section.contentInsets = Constants.sectionContentInsets
        let footerSize = layoutEnvironment.traitCollection.horizontalSizeClass ==
            .compact ? Constants.compactFooterSize : Constants.regularFooterSize
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constants.fullFractional),
                                                      heightDimension: .estimated(footerSize))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: TotalShowingHeaderView.elementKind,
            alignment: .top)
        sectionHeader.pinToVisibleBounds = true
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: LoadingFooterView.elementKind,
            alignment: .bottom)
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]

        return section
    }
}

extension CharacterListViewController {

    enum Constants {
        static let interSectionSpacing: CGFloat = 20.0
    }

    static func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (section: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = CharactersCollectionViewSection.init(rawValue: section) else {
                fatalError("Invalid section in collection view")
            }
            return section.layout(layoutEnvironment: layoutEnvironment)
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = Constants.interSectionSpacing

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}
