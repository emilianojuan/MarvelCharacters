//
//  CharactersListViewModelTests.swift
//  MarvelCharactersTests
//
//  Created by Emiliano Galitiello on 19/05/2022.
//

import XCTest
import Combine

@testable import MarvelCharacters

class CharactersListViewModelTests: XCTestCase {

    var cancelable: AnyCancellable?

    var bindings = Set<AnyCancellable>()

    override func setUpWithError() throws {
        bindings = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        bindings.forEach { $0.cancel() }
        bindings.removeAll()
        cancelable?.cancel()
        cancelable = nil
    }

    func testFirstLoading() throws {
        let mockService = MockCharacterListService()
        mockService.fetchCharactersCallback = { pageNumber, pageSize, _ in
            XCTAssertEqual(1, pageNumber)
            XCTAssertEqual(96, pageSize)
            let mockPage = CharactersPage(page: 1,
                                          searchText: nil,
                                          totalPages: 1,
                                          totalItems: 1,
                                          characters: [Character(id: 1,
                                                                 name: "mock",
                                                                 description: "desc",
                                                                 detailLinkURL: "url",
                                                                 wikiLinkURL: "url",
                                                                 comicLinkURL: "url",
                                                                 thumbnailURL: "url",
                                                                 comicsCount: 1,
                                                                 seriesCount: 1,
                                                                 storiesCount: 1,
                                                                 eventsCount: 1)])
            return Just(mockPage).mapError({ _ in
                MockError()
            }).eraseToAnyPublisher()
        }
        let charactersListViewModel = CharacterListViewModel(characterListService: mockService)

        let isLoadingExpectation = expectation(description: "is loading is called twice first true then false")
        var loading = true
        isLoadingExpectation.expectedFulfillmentCount = 2
        charactersListViewModel.$isLoading.dropFirst().sink { value in
            XCTAssertEqual(loading, value)
            loading.toggle()
            isLoadingExpectation.fulfill()
        }.store(in: &bindings)

        let resultExpectation = expectation(description: "a list of characters with one item")
        charactersListViewModel.$charactersItems.dropFirst().sink { items in
            XCTAssert(items.count == 1)
            resultExpectation.fulfill()
        }.store(in: &bindings)

        let resultShowText = expectation(description: "a description of the result is provided")
        charactersListViewModel.$showingTotalText.dropFirst().sink { string in
            XCTAssertEqual("Showing 1 of 1", string)
            resultShowText.fulfill()
        }.store(in: &bindings)
        charactersListViewModel.onViewDidLoad()
        wait(for: [isLoadingExpectation, resultExpectation, resultShowText], timeout: 1)
    }

    func testSecondLoading() throws {
        let mockService = MockCharacterListService()
        let firstPageCharacters = (1...96).map { id in
            Character(id: id,
                      name: "mock \(id)",
                      description: "desc",
                      detailLinkURL: "url",
                      wikiLinkURL: "url",
                      comicLinkURL: "url",
                      thumbnailURL: "url",
                      comicsCount: 1,
                      seriesCount: 1,
                      storiesCount: 1,
                      eventsCount: 1)
        }
        let firstPage = CharactersPage(page: 1, searchText: nil,
                                       totalPages: 2,
                                       totalItems: 192,
                                       characters: firstPageCharacters)
        let secondPageCharacters = (97...192).map { id in
            Character(id: id,
                      name: "mock \(id)",
                      description: "desc",
                      detailLinkURL: "url",
                      wikiLinkURL: "url",
                      comicLinkURL: "url",
                      thumbnailURL: "url",
                      comicsCount: 1,
                      seriesCount: 1,
                      storiesCount: 1,
                      eventsCount: 1)
        }
        let secondPage = CharactersPage(page: 2, searchText: nil,
                                        totalPages: 2,
                                        totalItems: 192,
                                        characters: secondPageCharacters)
        mockService.fetchCharactersCallback = { pageNumber, _, _ in
            var page = firstPage
            if pageNumber == 2 {
                page = secondPage
            }
            return Just(page).mapError({ _ in
                MockError()
            }).eraseToAnyPublisher()
        }
        let charactersListViewModel = CharacterListViewModel(characterListService: mockService)

        let resultExpectation = expectation(description: "")
        resultExpectation.expectedFulfillmentCount = 2
        var count = 0
        charactersListViewModel.$charactersItems.sink { items in
            XCTAssertEqual(count*96, items.count)
            count += 1
            resultExpectation.fulfill()
        }.store(in: &bindings)
        charactersListViewModel.onViewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            charactersListViewModel.onReachedPageEnd()
        }
        wait(for: [resultExpectation], timeout: 3)
    }

    func testTextSearch() throws {
        let mockService = MockCharacterListService()
        let searchText = "text"
        mockService.fetchCharactersCallback = { pageNumber, pageSize, searchText in
            XCTAssertEqual(1, pageNumber)
            XCTAssertEqual(96, pageSize)
            XCTAssertEqual("text", searchText)
            let mockPage = CharactersPage(page: 1,
                                          searchText: searchText,
                                          totalPages: 1,
                                          totalItems: 1,
                                          characters: [Character(id: 1,
                                                                 name: "mock",
                                                                 description: "desc",
                                                                 detailLinkURL: "url",
                                                                 wikiLinkURL: "url",
                                                                 comicLinkURL: "url",
                                                                 thumbnailURL: "url",
                                                                 comicsCount: 1,
                                                                 seriesCount: 1,
                                                                 storiesCount: 1,
                                                                 eventsCount: 1)])
            return Just(mockPage).mapError({ _ in
                MockError()
            }).eraseToAnyPublisher()
        }

        let charactersListViewModel = CharacterListViewModel(characterListService: mockService)

        let resultExpectation = expectation(description: "")
        charactersListViewModel.$charactersItems.dropFirst().sink { items in
            XCTAssert(items.count == 1)
            resultExpectation.fulfill()
        }.store(in: &bindings)

        let resultShowText = expectation(description: "")
        charactersListViewModel.$showingTotalText.dropFirst().sink { string in
            XCTAssertEqual("Showing 1 of 1", string)
            resultShowText.fulfill()
        }.store(in: &bindings)

        charactersListViewModel.onSearchTextChanged(searchText)
        wait(for: [resultExpectation, resultShowText], timeout: 3)
    }

    func testEmptySearch() throws {
        let mockService = MockCharacterListService()

        let fetchCharactersCallbackIsNotCalled = expectation(description: "This should not be called")
        fetchCharactersCallbackIsNotCalled.isInverted = true
        mockService.fetchCharactersCallback = { _, _, searchText in
            fetchCharactersCallbackIsNotCalled.fulfill()
            let mockPage = CharactersPage(page: 1,
                                          searchText: nil,
                                          totalPages: 1,
                                          totalItems: 1,
                                          characters: [Character(id: 1,
                                                                 name: "mock",
                                                                 description: "desc",
                                                                 detailLinkURL: "url",
                                                                 wikiLinkURL: "url",
                                                                 comicLinkURL: "url",
                                                                 thumbnailURL: "url",
                                                                 comicsCount: 1,
                                                                 seriesCount: 1,
                                                                 storiesCount: 1,
                                                                 eventsCount: 1)])
            return Just(mockPage).mapError({ _ in
                MockError()
            }).eraseToAnyPublisher()
        }

        let charactersListViewModel = CharacterListViewModel(characterListService: mockService)

        let resultExpectation = expectation(description: "")
        charactersListViewModel.$charactersItems.dropFirst().sink { items in
            XCTAssert(items.count == 0)
            resultExpectation.fulfill()
        }.store(in: &bindings)

        let resultShowText = expectation(description: "")
        resultShowText.expectedFulfillmentCount = 1

        charactersListViewModel.$showingTotalText.dropFirst().sink { string in
            XCTAssertEqual("Showing 0 of 0", string)
            resultShowText.fulfill()
        }.store(in: &bindings)
        charactersListViewModel.onSearchTextChanged("")
        wait(for: [fetchCharactersCallbackIsNotCalled, resultExpectation, resultShowText], timeout: 3)
    }
    
    func testCancelSearch() throws {
        let mockService = MockCharacterListService()

        mockService.fetchCharactersCallback = { _, _, searchText in
            let mockPage = CharactersPage(page: 1,
                                          searchText: nil,
                                          totalPages: 1,
                                          totalItems: 1,
                                          characters: [Character(id: 1,
                                                                 name: "mock",
                                                                 description: "desc",
                                                                 detailLinkURL: "url",
                                                                 wikiLinkURL: "url",
                                                                 comicLinkURL: "url",
                                                                 thumbnailURL: "url",
                                                                 comicsCount: 1,
                                                                 seriesCount: 1,
                                                                 storiesCount: 1,
                                                                 eventsCount: 1)])
            return Just(mockPage).mapError({ _ in
                MockError()
            }).eraseToAnyPublisher()
        }

        let charactersListViewModel = CharacterListViewModel(characterListService: mockService)

        let resultExpectation = expectation(description: "")
        charactersListViewModel.$charactersItems.dropFirst().sink { items in
            XCTAssert(items.count == 1)
            resultExpectation.fulfill()
        }.store(in: &bindings)

        let resultShowText = expectation(description: "")
        resultShowText.expectedFulfillmentCount = 1

        charactersListViewModel.$showingTotalText.dropFirst().sink { string in
            XCTAssertEqual("Showing 1 of 1", string)
            resultShowText.fulfill()
        }.store(in: &bindings)
        charactersListViewModel.onViewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            charactersListViewModel.onSearchDidCancel()
        }
        wait(for: [resultExpectation, resultShowText], timeout: 3)
    }
}
