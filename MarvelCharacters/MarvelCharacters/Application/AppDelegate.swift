//
//  AppDelegate.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 11/05/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var applicationCoordinator: ApplicationCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let environment = buildDefaultEnvironment()
        applicationCoordinator = ApplicationCoordinator(window: window, environment: environment)
        applicationCoordinator?.start()
        return true
    }
}

extension AppDelegate {

    func buildDefaultEnvironment() -> EnvironmentProtocol {
        let characterRepository = CharacterRepository(apiClient: MoyaMarvelAPIClient())
        let characterListService = CharacterListService(characterRepository: characterRepository)
        return Environment(characterListService: characterListService)
    }
}
