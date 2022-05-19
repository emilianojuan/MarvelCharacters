//
//  CharacterListService.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 19/05/2022.
//

import Foundation
import Combine

/// A service to search and list for characters.
protocol CharacterListService {

    /// See `CharacterRepository.fetchCharacters` for reference
    func fetchCharacters(pageNumber: Int, pageSize: Int, nameStartsWith: String?) -> AnyPublisher<CharactersPage, Error>
}
