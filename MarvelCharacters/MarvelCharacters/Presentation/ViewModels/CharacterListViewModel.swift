//
//  CharacterListViewModel.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 15/05/2022.
//

import Foundation
import Combine

protocol CharacterListViewModelNavigationDelegate: AnyObject {

    func showDetails(for character: Character)
    func show(_ error: Error)
}

protocol CharacterListViewModelInput {

    func onViewDidLoad()
    func onReachedPageEnd()
    func onSearchTextChanged(_ searchText: String)
    func onSearchDidCancel()
    func didSelectCharacter(with id: CharacterListItem.ID)
}

final class CharacterListViewModel {

    private enum Constants {
        static let pageSize = 96
    }

    private let characterListService: CharacterListService
    private var state: CharacterListViewModel.State = .initialState {
        didSet {
            stateDidUpdate()
        }
    }
    private var lastListingState: CharacterListViewModel.State?
    private var cancelable: AnyCancellable?

    weak var navigationDelegate: CharacterListViewModelNavigationDelegate?

    @Published var charactersItems: [CharacterListItem] = []
    @Published var isLoading = false
    @Published var showingTotalText: String = ""

    init(characterListService: CharacterListService) {
        self.characterListService = characterListService
    }

    deinit {
        cancelable?.cancel()
        cancelable = nil
    }

    private func loadFirstPage() {
        loadPage(pageNumber: 1, nameStartsWith: nil)
    }

    private func loadNextPage() {
        guard !isLoading, state.hasMoreResults() else {
            return
        }
        let nextPageNumber = state.pageNumber + 1
        let searchText = state.searchText
        loadPage(pageNumber: nextPageNumber, nameStartsWith: searchText)
    }

    private func updateSearchText(_ searchText: String) {
        guard searchText != state.searchText else {
            cancelable?.cancel()
            return
        }
        if searchText.isEmpty {
            cancelable?.cancel()
            state = .emptySearchState
        } else {
            if state.searchText == nil {
                lastListingState = state
            }
            loadPage(pageNumber: 1, nameStartsWith: searchText)
        }
    }

    private func loadPage(pageNumber: Int, nameStartsWith: String?) {
        isLoading = true
        cancelable?.cancel()
        cancelable = characterListService.fetchCharacters(pageNumber: pageNumber,
                                                          pageSize: Constants.pageSize,
                                                          nameStartsWith: nameStartsWith)
        .sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.show(error)
            default: break
            }
        }, receiveValue: { [weak self] receivedPage in
            self?.updateListing(page: receivedPage)
        })
    }

    private func updateListing(page: CharactersPage) {
        state = state.byUpdating(with: page)
    }

    private func stateDidUpdate() {
        isLoading = false
        charactersItems = state.characterListItems
        showingTotalText = state.resultsDescription
    }

    private func restoreLastListingState() {
        guard let lastState = lastListingState else {
            return
        }
        cancelable?.cancel()
        state = lastState
    }

    private func show(_ error: Error) {
        navigationDelegate?.show(error)
    }
}

extension CharacterListViewModel: CharacterListViewModelInput {

    func onViewDidLoad() {
        loadFirstPage()
    }

    func onReachedPageEnd() {
        loadNextPage()
    }

    func onSearchTextChanged(_ searchText: String) {
        updateSearchText(searchText)
    }

    func onSearchDidCancel() {
        restoreLastListingState()
    }

    func didSelectCharacter(with id: CharacterListItem.ID) {
        guard let character = state.characters.first(where: { $0.id == id }) else {
            return
        }
        navigationDelegate?.showDetails(for: character)
    }
}
