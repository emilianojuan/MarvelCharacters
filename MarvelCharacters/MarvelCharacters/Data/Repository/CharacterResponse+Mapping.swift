//
//  CharacterResponse+Mapping.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 16/05/2022.
//

import Foundation

extension CharacterResponse {

    var character: Character {
        var thumbnailURL = ""
        if let path = thumbnail?.path, let fileExtension = thumbnail?.fileExtension {
            thumbnailURL = "\(path).\(fileExtension)"
        }
        return Character(id: id ?? UUID().hashValue,
                         name: name ?? "",
                         description: description,
                         detailLinkURL: urls?.first { $0.type == UrlResponseType.detail }?.url,
                         wikiLinkURL: urls?.first { $0.type == UrlResponseType.wiki }?.url,
                         comicLinkURL: urls?.first { $0.type == UrlResponseType.comiclink }?.url,
                         thumbnailURL: thumbnailURL,
                         comicsCount: comics?.available ?? 0,
                         seriesCount: series?.available ?? 0,
                         storiesCount: stories?.available ?? 0,
                         eventsCount: events?.available ?? 0)

    }
}
