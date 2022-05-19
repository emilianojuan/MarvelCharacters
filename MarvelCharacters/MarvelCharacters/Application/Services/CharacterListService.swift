//
//  CharacterListService.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 19/05/2022.
//

import Foundation
import Combine

protocol CharacterListService {

    func fetchCharacters(pageNumber: Int, pageSize: Int, nameStartsWith: String?) -> AnyPublisher<CharactersPage, Error>
}
