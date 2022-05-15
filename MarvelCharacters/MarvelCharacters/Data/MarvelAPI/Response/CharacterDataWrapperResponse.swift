//
//  CharacterDataWrapperResponse.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 14/05/2022.
//

import Foundation

struct CharacterDataWrapperResponse: Codable {
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let etag: String?
    let data: CharacterDataContainerResponse?
}
