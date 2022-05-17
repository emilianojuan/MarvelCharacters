//
//  CharacterResponse.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 14/05/2022.
//

import Foundation

struct CharacterResponse: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let modified: String?
    let resourceURI: String?
    let urls: [UrlResponse]?
    let thumbnail: ImageResponse?
    let comics: MediaListResponse?
    let stories: MediaListResponse?
    let events: MediaListResponse?
    let series: MediaListResponse?
}
