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

final class CharacterListViewController: UIViewController {

    private let characterListViewModel: CharacterListViewModel

    private let searchController: UISearchController
    private var dataSource: UICollectionViewDiffableDataSource<Section, CharacterListItem>?
    private var bindings = Set<AnyCancellable>()

    let charactersCollectionView: UICollectionView
    let activityIndicator = UIActivityIndicatorView()
    let showingTotalLabel = UILabel()

    @Published private var searchText: String = ""

    init(characterListViewModel: CharacterListViewModel) {
        self.searchController = UISearchController()
        self.charactersCollectionView = UICollectionView(frame: .zero,
                                                         collectionViewLayout: CharacterListViewController.createLayout())
        self.characterListViewModel = characterListViewModel
        super.init(nibName: nil, bundle: nil)
        setUpSearchController()
        setUpCharactersCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = NSLocalizedString("Character.List.Title", comment: "")
        bind()
        characterListViewModel.onViewDidLoad()
    }

    private func setUpSearchController() {
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.clearButtonMode = .always
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func setUpCharactersCollectionView() {
        dataSource = diffableDataSource
        charactersCollectionView.dataSource = dataSource
        charactersCollectionView.delegate = self
        view.addSubview(charactersCollectionView)
        charactersCollectionView.edgeAnchors == view.edgeAnchors
    }

    private func bind() {
        bindings = [
            characterListViewModel.$isLoading.sink(receiveValue: { [weak self] loading in
                if loading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }),
            characterListViewModel.$charactersItems.sink { [weak self] characters in
                guard var snapshot = self?.dataSource?.snapshot(for: .characters) else {
                    return
                }
                snapshot.deleteAll()
                snapshot.append(characters)
                self?.dataSource?.apply(snapshot, to: .characters, animatingDifferences: true)
            },
            characterListViewModel.$showingTotalText.sink(receiveValue: { [weak self] text in
                self?.showingTotalLabel.text = text
            }),
            $searchText.debounce(for: .seconds(0.3),
                                 scheduler: RunLoop.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] value in
                self?.characterListViewModel.onSearchTextChanged(value)
            })
        ]
    }
}

extension CharacterListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        characterListViewModel.onSearchDidCancel()
    }
}

extension CharacterListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let character = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        characterListViewModel.didSelectCharacter(with: character.id)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollHeight = scrollView.frame.size.height
        if offsetY >= contentHeight - scrollHeight {
            characterListViewModel.onReachedPageEnd()
        }
    }
}
