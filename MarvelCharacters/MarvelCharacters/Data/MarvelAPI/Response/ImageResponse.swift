//
//  ImageResponse.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 14/05/2022.
//

import Foundation

struct ImageResponse: Codable {
    let path: String?
    let fileExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case fileExtension = "extension"
    }
}
