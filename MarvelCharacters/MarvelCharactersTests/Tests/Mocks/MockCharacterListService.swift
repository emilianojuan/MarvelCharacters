//
//  MockCharacterListService.swift
//  MarvelCharactersTests
//
//  Created by Emiliano Galitiello on 19/05/2022.
//

import Foundation
import Combine

@testable import MarvelCharacters

class MockCharacterListService: CharacterListService {

    var fetchCharactersCallback: ((_ pageNumber: Int, _ pageSize: Int, _ nameStartsWith: String?) -> AnyPublisher<CharactersPage, Error>)?

    func fetchCharacters(pageNumber: Int, pageSize: Int, nameStartsWith: String?) -> AnyPublisher<CharactersPage, Error> {
        fetchCharactersCallback!(pageNumber, pageSize, nameStartsWith)
    }
}
