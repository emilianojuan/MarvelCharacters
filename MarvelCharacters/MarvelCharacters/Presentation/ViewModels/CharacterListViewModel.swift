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

    let characterRepository: CharacterRepository

    private var currentPage = 1

    private var searchResults: [Character] = []

    private var characters: [Character] = []

    init(characterRepository: CharacterRepository) {
        self.characterRepository = characterRepository

    }

    weak var navigationDelegate: CharacterListViewModelNavigationDelegate?

    func viewDidLoad() {

    }
}

extension CharacterListViewModel {

    func didSelectCharacter(character: Character) {
        navigationDelegate?.showCharacterDetails(character: character)
    }
}
