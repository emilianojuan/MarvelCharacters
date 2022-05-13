//
//  CharacterListViewController.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 11/05/2022.
//

import UIKit
import Anchorage

enum Section {
    case characters
}

struct Character: Hashable {
    let id = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}

class CharacterListViewController: UIViewController {

    fileprivate let sectionHeaderElementKind = "SectionHeader"

    var dataSource: UICollectionViewDiffableDataSource<Section, Character>?

    let searchController: UISearchController
    let charactersCollectionView: UICollectionView

    init() {
        searchController = UISearchController()
        charactersCollectionView = UICollectionView(frame: .zero,
                                                    collectionViewLayout: CharacterListViewController.createLayout())
        super.init(nibName: nil, bundle: nil)
        setUpSearchController()
        setUpCharactersCollectionView()
        setInitialData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "Marvel Characters"
    }

    private func setUpSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func setUpCharactersCollectionView() {
        dataSource = createDataSource(collectionView: charactersCollectionView)
        charactersCollectionView.dataSource = dataSource
        view.addSubview(charactersCollectionView)
        charactersCollectionView.edgeAnchors == view.edgeAnchors
    }

    private static func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let columnCount = layoutEnvironment.traitCollection.horizontalSizeClass.rawValue * 4
            print(CGFloat(1.0/CGFloat(columnCount)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(CGFloat(1.0/CGFloat(columnCount))))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columnCount)
            group.interItemSpacing = .fixed(8)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)

            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)

//        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "SectionBackground")
        return layout
    }

    private func createDataSource(collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Character> {
        let cellRegistration = UICollectionView.CellRegistration<CharacterListCell, Character> { [weak self] _, _, _ in
            guard let self = self else { return }

        }

        return UICollectionViewDiffableDataSource<Section, Character>(collectionView: collectionView,
                                                                      cellProvider: { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        })
    }

    private func setInitialData() {
        // Initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([Section.characters])
        let items = [Character(), Character(), Character(), Character(), Character(), Character(), Character(), Character(), Character(), Character()]
        snapshot.appendItems(items, toSection: Section.characters)
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
}

extension CharacterListViewController: UISearchControllerDelegate {

}

extension CharacterListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

    }

}

extension CharacterListViewController: UISearchBarDelegate {

}
