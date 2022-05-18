//
//  CharacterViewModel.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 17/05/2022.
//

import Foundation

protocol CharacterDetailViewModelNavigationDelegate: AnyObject {

    func close()
    func navigateToLink(url: URL)
}

final class CharacterDetailViewModel {

    private let character: Character

    weak var navigationDelegate: CharacterDetailViewModelNavigationDelegate?

    init(character: Character) {
        self.character = character
    }

    var name: String {
        return character.name
    }

    var description: String {
        var characterDescription = NSLocalizedString("Character.Detail.NoDescription", comment: "")
        if let description = character.description, !description.isEmpty {
            characterDescription = description
        }
        return characterDescription
    }

    var thumbnailURL: URL? {
        guard let urlString = character.thumbnailURL, let url = URL(string: urlString) else {
            return nil
        }
        return url
    }

    var comicsCount: String {
        "\(character.comicsCount)"
    }

    var seriesCount: String {
        "\(character.seriesCount)"
    }

    var storiesCount: String {
        "\(character.storiesCount)"
    }

    var eventsCount: String {
        "\(character.eventsCount)"
    }

    var showDetailLink: Bool {
        return character.detailLinkURL != nil
    }

    var showWikiLink: Bool {
        return character.wikiLinkURL != nil
    }

    var showComicLink: Bool {
        return character.comicLinkURL != nil
    }

    func goToDetails() {
        guard let urlString = character.detailLinkURL, let url = URL(string: urlString) else {
            return
        }
        navigationDelegate?.navigateToLink(url: url)
    }

    func goToWiki() {
        guard let urlString = character.wikiLinkURL, let url = URL(string: urlString) else {
            return
        }
        navigationDelegate?.navigateToLink(url: url)
    }

    func goToComics() {
        guard let urlString = character.comicLinkURL, let url = URL(string: urlString) else {
            return
        }
        navigationDelegate?.navigateToLink(url: url)
    }

    func close() {
        navigationDelegate?.close()
    }
}
