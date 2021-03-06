//
//  CharactersListCoordinator.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 12/05/2022.
//

import Foundation
import UIKit

final class CharactersListCoordinator: Coordinator {

    var environment: EnvironmentProtocol

    var navigationController: UINavigationController?

    init(navigationController: UINavigationController, environment: EnvironmentProtocol) {
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

    func showDetails(for character: Character) {
        let characterDetailViewModel = CharacterDetailViewModel(character: character)
        characterDetailViewModel.navigationDelegate = self
        let characterDetailViewController = CharacterDetailViewController(characterViewModel: characterDetailViewModel)
        navigationController?.present(characterDetailViewController, animated: true)
    }

    func show(_ error: Error) {
        let alertController: UIAlertController = UIAlertController(title: NSLocalizedString("Error.Title", comment: ""),
                                                                   message: error.localizedDescription,
                                                                   preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Error.Accept", comment: ""),
                                                    style: .default) { (_) -> Void in

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
