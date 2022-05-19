//
//  DefaultCharacterListService.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 19/05/2022.
//

import Foundation
import Combine

final class DefaultCharacterListService: CharacterListService {

    private let characterRepository: CharacterRepository

    init(characterRepository: CharacterRepository) {
        self.characterRepository = characterRepository
    }

    func fetchCharacters(pageNumber: Int, pageSize: Int, nameStartsWith: String?) -> AnyPublisher<CharactersPage, Error> {
        return characterRepository.fetchCharacters(pageNumber: pageNumber, pageSize: pageSize, nameStartsWith: nameStartsWith)
    }
}
