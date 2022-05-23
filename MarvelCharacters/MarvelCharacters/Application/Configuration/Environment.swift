//
//  DefaultEnvironment.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 12/05/2022.
//

import Foundation

final class Environment: EnvironmentProtocol {

    let characterListService: CharacterListServiceProtocol

    init(characterListService: CharacterListServiceProtocol) {
        self.characterListService = characterListService
    }
}
