//
//  CharacterDataContainerResponse.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 14/05/2022.
//

import Foundation

struct CharacterDataContainerResponse: Codable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [CharacterResponse]?
}
