//
//  Character.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 16/05/2022.
//

import Foundation

struct Character: Identifiable, Equatable {

    typealias Identifier = Int

    let id: Identifier
    let name: String
    let description: String?
    let detailLinkURL: String?
    let wikiLinkURL: String?
    let comicLinkURL: String?
    let thumbnailURL: String?
    let comicsCount: Int
    let seriesCount: Int
    let storiesCount: Int
    let eventsCount: Int
}

struct CharactersPage: Equatable {
    let page: Int
    let totalPages: Int
    let totalItems: Int
    let characters: [Character]
}
