//
//  CharacterRepository.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 16/05/2022.
//

import Foundation
import Combine

protocol CharacterRepository {

    var maxPageSize: Int { get }
    /**
     Fetches a list of *[characters]*
     - Parameters:
        - pageNumber: A number greater or equal than 1 that determins the window of the charecters list to be fetched
        - pageSize: Constraints the max amount of results, should be greater than 0 and less or equal than `maxPageSize`
     - Returns: returns an observable publisher than can output a `CharactersPage` containing the result or an error
     */
    func fetchCharacters(pageNumber: Int, pageSize: Int, nameStartsWith: String?) -> AnyPublisher<CharactersPage, Error>
}

final class CharacterRepositoryImplementation: CharacterRepository {

    var maxPageSize: Int {
        return apiClient.maxPageSize
    }

    private let apiClient: MarvelAPIClient

    init(apiClient: MarvelAPIClient) {
        self.apiClient = apiClient
    }

    func fetchCharacters(pageNumber: Int, pageSize: Int, nameStartsWith: String?) -> AnyPublisher<CharactersPage, Error> {
        assert(pageNumber >= 1)
        assert(pageSize <= maxPageSize && pageSize > 0)
        let offset = (pageNumber - 1) * pageSize
        return apiClient.getCharacters(nameStartsWith: nameStartsWith,
                                       limit: pageSize,
                                       offset: offset)
        .receive(on: DispatchQueue.global())
        .map { response in
            guard let data = response.data,
                  let results = data.results,
                  let total = data.total else {
                return CharactersPage(page: 0, totalPages: 0, characters: [])
            }
            let pages = Int(ceil(Double(total) / Double(pageSize)))
            return CharactersPage(page: pageNumber, totalPages: pages, characters: results.map { $0.character })
        }.mapError { apiError in
            apiError.underlying
        }.receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
