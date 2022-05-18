//
//  CharacterListViewController+Layout.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 18/05/2022.
//

import UIKit

enum Section: Int {

    case characters

    func layout(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let columnCount = layoutEnvironment.traitCollection.horizontalSizeClass.rawValue * 3
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(CGFloat(1.0/CGFloat(columnCount))))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columnCount)
        group.interItemSpacing = .fixed(1)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        let footerSize = layoutEnvironment.traitCollection.horizontalSizeClass == .compact ? 44.0 : 60.0
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(footerSize))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: LoadingFooterView.elementKind,
            alignment: .bottom)
        section.boundarySupplementaryItems = [sectionFooter]

        return section
    }
}

extension CharacterListViewController {

    static func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (section: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = Section.init(rawValue: section) else {
                fatalError("Invalid section in collection view")
            }
            return section.layout(layoutEnvironment: layoutEnvironment)
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}
