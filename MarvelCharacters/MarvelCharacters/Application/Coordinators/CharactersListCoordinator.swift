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
        let characterListViewModel = CharacterListViewModel(characterListService: environment.characterListService)
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

    func show(_ error: Error) {
        let alertController: UIAlertController = UIAlertController(title: "An error has occured",
                                                                   message: error.localizedDescription,
                                                                   preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in

        }
        alertController.addAction(okAction)
        self.navigationController?.present(alertController,
                                           animated: true,
                                           completion: nil)
    }
}

extension CharactersListCoordinator: CharacterDetailViewModelNavigationDelegate {

    func close() {
        navigationController?.dismiss(animated: true)
    }

    func navigateToLink(url: URL) {
        UIApplication.shared.open(url)
    }
}
