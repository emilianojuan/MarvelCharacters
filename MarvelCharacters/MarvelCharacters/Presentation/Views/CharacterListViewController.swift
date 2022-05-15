//
//  CharacterListViewController.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 11/05/2022.
//

import UIKit
import Anchorage

enum Section: Int {
    case characters
}

enum Item: Hashable {
    case character
}
class CharacterListViewController: UIViewController {

    var dataSource: UICollectionViewDiffableDataSource<Section, Item>?

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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("TRAIT COLLETION \(traitCollection.horizontalSizeClass.rawValue)")
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
        charactersCollectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: "footer", withReuseIdentifier: "footer")
        dataSource = createDataSource(collectionView: charactersCollectionView)
        charactersCollectionView.dataSource = dataSource
        charactersCollectionView.delegate = self
        view.addSubview(charactersCollectionView)
        charactersCollectionView.edgeAnchors == view.edgeAnchors
    }

    private static func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (section: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch Section(rawValue: section) {
            case .characters:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let columnCount = layoutEnvironment.traitCollection.horizontalSizeClass.rawValue * 4
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(CGFloat(1.0/CGFloat(columnCount))))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columnCount)
                group.interItemSpacing = .fixed(8)

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)

                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                              heightDimension: .estimated(44))
                let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize,
                    elementKind: "footer",
                    alignment: .bottom)
                section.boundarySupplementaryItems = [sectionFooter]

                return section
            default:
                fatalError("This collection view only has two sections")
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)

//        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "SectionBackground")
        return layout
    }

    private func createDataSource(collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Item> {

        let characterListCellRegistration = UICollectionView.CellRegistration<CharacterListCell, Item> { [weak self] _, _, _ in

        }

        let footerRegistration = UICollectionView.SupplementaryRegistration<LoadingFooterView>(elementKind: "footer") { (supplementaryView, _, _) in
            supplementaryView.activityIndicatorView.startAnimating()
        }

        let datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView,
                                                                           cellProvider: { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            switch Section(rawValue: indexPath.section) {
            case .characters:
                return collectionView.dequeueConfiguredReusableCell(using: characterListCellRegistration, for: indexPath, item: identifier)
            default:
                fatalError("This collection view only supports one section")
            }
        })
        datasource.supplementaryViewProvider = { (_ collectionView: UICollectionView, _ elementKind: String, _ indexPath: IndexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
        }
        return datasource
    }

    private func setInitialData() {
        // Initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([Section.characters])
        let items = (1...30).map { _ in  Item.character }
        snapshot.appendItems(items, toSection: Section.characters)
//        snapshot.appendItems([.refresh], toSection: .refresh)

        dataSource?.applySnapshotUsingReloadData(snapshot)
    }

    private func loadNextPage() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
            guard var snapshot = self?.dataSource?.snapshot(for: .characters) else {
                return
            }
            let items = (1...30).map { _ in  Item.character }
            snapshot.append(items)
            self?.dataSource?.apply(snapshot, to: .characters)
        }
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

extension CharacterListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = UIViewController()
        controller.view.backgroundColor = .red
        navigationController?.present(controller, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollHeight = scrollView.frame.size.height
        if offsetY >= contentHeight - scrollHeight {
            loadNextPage()
        }
    }
}
