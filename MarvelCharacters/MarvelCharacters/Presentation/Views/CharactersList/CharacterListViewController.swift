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

extension Character: Hashable {

    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class CharacterListViewController: UIViewController {

    let characterListViewModel: CharacterListViewModel

    private let searchController: UISearchController
    private let charactersCollectionView: UICollectionView

    private var dataSource: UICollectionViewDiffableDataSource<Section, Character>?

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
        characterListViewModel.viewDidLoad()
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
        dataSource = CharacterListViewController.diffableDataSource(for: charactersCollectionView)
        charactersCollectionView.dataSource = dataSource
        charactersCollectionView.delegate = self
        view.addSubview(charactersCollectionView)
        charactersCollectionView.edgeAnchors == view.edgeAnchors
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
        guard let character = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        characterListViewModel.didSelectCharacter(character: character)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollHeight = scrollView.frame.size.height
        if offsetY >= contentHeight - scrollHeight {
            // signal bottom reached
        }
    }
}
