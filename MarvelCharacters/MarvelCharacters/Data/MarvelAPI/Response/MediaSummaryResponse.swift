//
//  MediaSummaryResponse.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 14/05/2022.
//

import Foundation

struct MediaSummaryResponse: Codable {
    let resourceUri: String?
    let name: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case name, type
        case resourceUri = "resourceURI"
    }
}
