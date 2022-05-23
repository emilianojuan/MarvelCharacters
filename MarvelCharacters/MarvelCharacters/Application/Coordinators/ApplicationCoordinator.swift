//
//  ApplicationCoordinator.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 11/05/2022.
//

import UIKit

final class ApplicationCoordinator: Coordinator {

    var environment: EnvironmentProtocol

    var navigationController: UINavigationController?

    let window: UIWindow

    private let charactersListCoordinator: CharactersListCoordinator

    init(window: UIWindow, environment: EnvironmentProtocol) {
        self.environment = environment
        self.window = window
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        self.charactersListCoordinator = CharactersListCoordinator(navigationController: navigationController,
                                                                   environment: environment)
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        charactersListCoordinator.start()
    }
}
