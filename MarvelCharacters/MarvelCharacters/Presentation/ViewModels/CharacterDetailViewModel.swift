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

    weak var navigationDelegate: CharacterDetailViewModelNavigationDelegate?

    let name: String
    let description: String?
    let thumbnailURL: URL?
    let comicsCount: String
    let seriesCount: String
    let storiesCount: String
    let eventsCount: String

    private let detailLinkURL: URL?
    private let comicLinkURL: URL?
    private let wikiLinkURL: URL?

    init(character: Character) {
        name = character.name
        if let description = character.description, !description.isEmpty {
            self.description = description
        } else {
            description = NSLocalizedString("Character.Detail.NoDescription", comment: "")
        }
        if let thumbnailString = character.thumbnailURL, let url = URL(string: thumbnailString) {
            thumbnailURL = url
        } else {
            thumbnailURL = nil
        }
        comicsCount = "\(character.comicsCount)"
        seriesCount = "\(character.seriesCount)"
        storiesCount = "\(character.storiesCount)"
        eventsCount = "\(character.eventsCount)"
        if let detailLinkString = character.detailLinkURL, let url = URL(string: detailLinkString) {
            detailLinkURL = url
        } else {
            detailLinkURL = nil
        }
        if let comicLinkString = character.comicLinkURL, let url = URL(string: comicLinkString) {
            comicLinkURL = url
        } else {
            comicLinkURL = nil
        }
        if let wikiLinkString = character.wikiLinkURL, let url = URL(string: wikiLinkString) {
            wikiLinkURL = url
        } else {
            wikiLinkURL = nil
        }
    }

    var showDetailLink: Bool {
        return detailLinkURL != nil
    }

    var showWikiLink: Bool {
        return wikiLinkURL != nil
    }

    var showComicLink: Bool {
        return comicLinkURL != nil
    }

    func goToDetails() {
        guard let url = detailLinkURL else {
            return
        }
        navigationDelegate?.navigateToLink(url: url)
    }

    func goToWiki() {
        guard let url = wikiLinkURL else {
            return
        }
        navigationDelegate?.navigateToLink(url: url)
    }

    func goToComics() {
        guard let url = comicLinkURL else {
            return
        }
        navigationDelegate?.navigateToLink(url: url)
    }

    func close() {
        navigationDelegate?.close()
    }
}
