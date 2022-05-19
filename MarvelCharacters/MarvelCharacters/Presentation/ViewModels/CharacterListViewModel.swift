//
//  CharacterListViewModel.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 15/05/2022.
//

import Foundation
import Combine

protocol CharacterListViewModelNavigationDelegate: AnyObject {

    func showCharacterDetails(character: Character)
}

struct CharacterListItem: Hashable {

    let id: Int
    let name: String
    let thumbnailURL: URL?

    init(character: Character) {
        id = character.id
        name = character.name
        guard let thumbnailURLString = character.thumbnailURL, let url = URL(string: thumbnailURLString) else {
            thumbnailURL = nil
            return
        }
        thumbnailURL = url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class CharacterListViewModel {

    typealias PageNumber = Int
    typealias TotalPages = Int
    typealias TotalItems = Int
    typealias SearchTerm = String

    private static let pageSize = 96

    enum State {
        case listing(PageNumber, TotalPages, TotalItems)
        case searching(PageNumber, String, TotalPages, TotalItems)
    }

    private let characterListService: CharacterListService

    private var listingState = State.listing(0, 1, 0)

    private var previousListingState = State.listing(0, 1, 0)

    private var characters: [Character] = []
    private var charactersSearch: [Character] = []

    @Published var charactersItems: [CharacterListItem] = []
    @Published var isLoading = false
    @Published var showingTotalText: String = ""

    private var cancelable: AnyCancellable?

    var searchText: String? {
        didSet {
            guard let searchText = searchText else {
                listingState = previousListingState
                guard case .listing(_, _, let total) = listingState else {
                    return
                }
                charactersItems = characters.map { CharacterListItem(character: $0) }
                updateShowingTotalText(count: characters.count, total: total)
                charactersSearch.removeAll()
                return
            }
            switch listingState {
            case .listing:
                previousListingState = listingState
                listingState = .searching(0, searchText, 1, 0)
            case .searching:
                charactersSearch.removeAll()
                listingState = .searching(0, searchText, 1, 0)
            }
            loadNextPage()
        }
    }

    init(characterListService: CharacterListService) {
        self.characterListService = characterListService
    }

    deinit {
        cancelable?.cancel()
        cancelable = nil
    }

    weak var navigationDelegate: CharacterListViewModelNavigationDelegate?

    func viewDidLoad() {
        loadNextPage()
    }

    private func loadPage(pageNumber: PageNumber, nameStartsWith: String?) {
        if let nameStartsWith = nameStartsWith, nameStartsWith.isEmpty {
            charactersSearch.removeAll()
            charactersItems = characterListItems(from: charactersSearch)
            listingState = .searching(0, "", 1, 0)
            updateShowingTotalText(count: 0, total: 0)
            return
        }
        isLoading = true
        cancelable?.cancel()
        cancelable = characterListService.fetchCharacters(pageNumber: pageNumber,
                                                          pageSize: CharacterListViewModel.pageSize,
                                                          nameStartsWith: nameStartsWith)
        .sink(receiveCompletion: { [weak self] _ in
            self?.isLoading = false
        }, receiveValue: { [weak self] receivedPage in
            self?.updateListing(page: receivedPage)
        })
    }

    private func updateListing(page: CharactersPage) {
        switch listingState {
        case .listing:
            listingState = .listing(page.page, page.totalPages, page.totalItems)
            characters.append(contentsOf: page.characters)
            charactersItems.append(contentsOf: characterListItems(from: page.characters))
            updateShowingTotalText(count: characters.count, total: page.totalItems)
        case .searching(_, let searchTerm, _, _):
            listingState = .searching(page.page, searchTerm, page.totalPages, page.totalItems)
            charactersSearch.append(contentsOf: page.characters)
            charactersItems = characterListItems(from: charactersSearch)
            updateShowingTotalText(count: charactersSearch.count, total: page.totalItems)
        }
    }

    func loadNextPage() {
        var pageNumber: Int
        var totalPages: Int
        var nameStartsWith: String?
        switch listingState {
        case .listing(let page, let total, _):
            pageNumber = page
            totalPages = total
        case .searching(let page, let searchTerm, let total, _):
            pageNumber = page
            nameStartsWith = searchTerm
            totalPages = total
        }
        guard pageNumber < totalPages else {
            return
        }
        let nextPage = pageNumber + 1
        loadPage(pageNumber: nextPage, nameStartsWith: nameStartsWith)
    }

    private func updateShowingTotalText(count: Int, total: Int) {
        let localizedString = NSLocalizedString("Character.List.ShowingResults", comment: "")
        showingTotalText = String(format: localizedString, count, total)
    }

    private func characterListItems(from characters: [Character]) -> [CharacterListItem] {
        return characters.map { CharacterListItem(character: $0) }
    }
}

extension CharacterListViewModel {

    func didSelectCharacter(with id: Character.ID) {
        var characters: [Character]
        switch listingState {
        case .listing:
            characters = self.characters
        case .searching:
            characters = self.charactersSearch
        }
        guard let character = characters.first(where: { $0.id == id }) else {
            return
        }
        navigationDelegate?.showCharacterDetails(character: character)
    }
}
