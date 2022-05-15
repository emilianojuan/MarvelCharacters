//
//  MediaListResponse.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 14/05/2022.
//

import Foundation

struct MediaListResponse: Codable {
    let available: Int?
    let returned: Int?
    let collectionUri: String?
    let items: [MediaSummaryResponse]?

    enum CodingKeys: String, CodingKey {
        case available, returned, items
        case collectionUri = "collectionURI"
    }
}
