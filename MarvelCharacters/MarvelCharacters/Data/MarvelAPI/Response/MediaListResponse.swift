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
    let collectionURI: String?
    let items: [MediaSummaryResponse]?
}
