//
//  CharacterListViewModel.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 15/05/2022.
//

import Foundation
import Combine

protocol CharacterListViewModelNavigationDelegate: AnyObject {

    func showCharacterDetails(character: Character)
}

final class CharacterListViewModel: ObservableObject {

    let title = "Marvel Characters"

    let repository = CharacterRepositoryImplementation(apiClient: MoyaMarvelAPIClient())

    private var currentPage = 1

    private var searchResults: [Character] = []

    private var characters: [Character] = []

    weak var navigationDelegate: CharacterListViewModelNavigationDelegate?
}

extension CharacterListViewModel {

    func didSelectCharacter(character: Character) {
        navigationDelegate?.showCharacterDetails(character: character)
    }
}
