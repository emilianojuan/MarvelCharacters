//
//  CharacterListViewController.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 11/05/2022.
//

import UIKit
import Anchorage
import Combine
import Kingfisher

enum Section: Int {
    case characters
}

extension Character: Hashable {

    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class CharacterListViewController: UIViewController {

    let repository = CharacterRepositoryImplementation(apiClient: MoyaMarvelAPIClient())

    private let searchController: UISearchController
    private let charactersCollectionView: UICollectionView

    private var dataSource: UICollectionViewDiffableDataSource<Section, Character>?

    init(viewModel: CharacterListViewModel) {
        searchController = UISearchController()
        charactersCollectionView = UICollectionView(frame: .zero,
                                                    collectionViewLayout: CharacterListViewController.createLayout())
        super.init(nibName: nil, bundle: nil)
        setUpSearchController()
        setUpCharactersCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "Marvel Characters"
        loadNextPage()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("TRAIT COLLETION \(traitCollection.horizontalSizeClass.rawValue)")
    }

    private func setUpSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.clearButtonMode = .always
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

                let columnCount = layoutEnvironment.traitCollection.horizontalSizeClass.rawValue * 3
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(CGFloat(1.0/CGFloat(columnCount))))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columnCount)
                group.interItemSpacing = .fixed(1)

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 1
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)

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
        return layout
    }

    private func createDataSource(collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Character> {

        let characterListCellRegistration = UICollectionView.CellRegistration<CharacterListCell, Character> { cell, _, item in
            cell.thumbnailImageView.kf.indicatorType = .activity
            if let urlString = item.thumbnailURL, let url = URL(string: urlString) {
                cell.thumbnailImageView.kf.setImage(with: url,
    //                                                placeholder: R.Image.userPlaceholder,
                                                    options: [.transition(.fade(1)), .cacheOriginalImage])

            }
            cell.nameLabel.text = item.name
        }

        let footerRegistration = UICollectionView.SupplementaryRegistration<LoadingFooterView>(elementKind: "footer") { (supplementaryView, _, _) in
            supplementaryView.activityIndicatorView.startAnimating()
        }

        let dataSource = UICollectionViewDiffableDataSource<Section, Character>(collectionView: collectionView,
                                                                                        cellProvider: { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            switch Section(rawValue: indexPath.section) {
            case .characters:
                return collectionView.dequeueConfiguredReusableCell(using: characterListCellRegistration, for: indexPath, item: identifier)
            default:
                fatalError("This collection view only supports one section")
            }
        })
        dataSource.supplementaryViewProvider = { (_ collectionView: UICollectionView, _ elementKind: String, _ indexPath: IndexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([Section.characters])
        dataSource.applySnapshotUsingReloadData(snapshot)
        return dataSource
    }

    private func setInitialData(_ data: [Character]) {
        // Initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([Section.characters])
        snapshot.appendItems(data, toSection: Section.characters)
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }

    var pageCount = 1
    var cancel: AnyCancellable?
    private func loadNextPage() {
        cancel?.cancel()
        cancel = repository.fetchCharacters(pageNumber: pageCount, pageSize: 12*8, nameStartsWith: nil)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] response in
                guard var snapshot = self?.dataSource?.snapshot(for: .characters) else {
                    return
                }
                snapshot.append(response.characters)
                self?.dataSource?.apply(snapshot, to: .characters)
                self?.pageCount += 1
            })
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
