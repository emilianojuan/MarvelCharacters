//
//  DefaultEnvironment.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 12/05/2022.
//

import Foundation

final class DefaultEnvironment: Environment {

    let characterListService: CharacterListService

    init(characterListService: CharacterListService) {
        self.characterListService = characterListService
    }
}
