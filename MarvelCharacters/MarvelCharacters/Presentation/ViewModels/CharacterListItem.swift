//
//  CharacterListItem.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 22/05/2022.
//

import Foundation

struct CharacterListItem: Identifiable, Hashable {

    let id: Int
    let name: String
    let thumbnailURL: URL?

    init(character: Character) {
        id = character.id
        name = character.name
        guard let thumbnailURLString = character.thumbnailURL, let url = URL(string: thumbnailURLString) else {
            thumbnailURL = nil
            return
        }
        thumbnailURL = url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
