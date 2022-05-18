//
//  CharactersListCoordinator.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 12/05/2022.
//

import Foundation
import UIKit

final class CharactersListCoordinator: Coordinator {
    var environment: Environment

    var navigationController: UINavigationController?

    init(navigationController: UINavigationController, environment: Environment) {
        self.navigationController = navigationController
        self.environment = environment
    }

    func start() {
        let characterListViewModel = CharacterListViewModel()
        characterListViewModel.navigationDelegate = self
        let characterListViewController = CharacterListViewController(characterListViewModel: characterListViewModel)
        navigationController?.pushViewController(characterListViewController, animated: true)
    }
}

extension CharactersListCoordinator: CharacterListViewModelNavigationDelegate {

    func showCharacterDetails(character: Character) {
        let characterDetailViewModel = CharacterDetailViewModel(character: character)
        characterDetailViewModel.navigationDelegate = self
        let characterDetailViewController = CharacterDetailViewController(characterViewModel: characterDetailViewModel)
        navigationController?.present(characterDetailViewController, animated: true)
    }
}

extension CharactersListCoordinator: CharacterDetailViewModelNavigationDelegate {

    func navigateToLink(url: URL) {
        UIApplication.shared.open(url)
    }
}

