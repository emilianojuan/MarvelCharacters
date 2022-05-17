//
//  UrlResponse.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 14/05/2022.
//

import Foundation

enum UrlResponseType: String, Codable {
    case detail, wiki, comiclink
}

struct UrlResponse: Codable {
    let type: UrlResponseType?
    let url: String?
}
