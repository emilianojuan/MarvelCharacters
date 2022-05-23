//
//  CharacterListViewModel+State.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 22/05/2022.
//

import Foundation

extension CharacterListViewModel {

    struct State: Equatable {

        static let initialState = CharacterListViewModel.State(pageNumber: 0,
                                                               searchText: nil,
                                                               totalPages: 0,
                                                               characters: [],
                                                               totalItems: 0)

        static let emptySearchState = CharacterListViewModel.State(pageNumber: 0,
                                                                   searchText: "",
                                                                   totalPages: 0,
                                                                   characters: [],
                                                                   totalItems: 0)

        // This two properties describes what characters are in the charecters array
        let pageNumber: Int
        let searchText: String?

        // This three properties contains the result of the query described by the two latter properties
        let totalPages: Int
        let characters: [Character]
        let totalItems: Int

        var resultsDescription: String {
            let localizedString = NSLocalizedString("Character.List.ShowingResults", comment: "")
            return String(format: localizedString, characters.count, totalItems)
        }

        var characterListItems: [CharacterListItem] {
            return characters.map { CharacterListItem(character: $0) }
        }

        func hasMoreResults() -> Bool {
            return pageNumber < totalPages
        }

        func byUpdating(with charactersPage: CharactersPage) -> CharacterListViewModel.State {
            var characters: [Character]
            if let searchText = charactersPage.searchText, searchText != self.searchText {
                characters = charactersPage.characters
            } else {
                characters = self.characters + charactersPage.characters
            }
            return .init(pageNumber: charactersPage.page,
                         searchText: charactersPage.searchText,
                         totalPages: charactersPage.totalPages,
                         characters: characters,
                         totalItems: charactersPage.totalItems)
        }
    }
}
