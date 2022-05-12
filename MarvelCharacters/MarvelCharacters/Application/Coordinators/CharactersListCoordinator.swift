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
        let characterListViewController = CharacterListViewController()
        navigationController?.pushViewController(characterListViewController, animated: true)
    }
}
