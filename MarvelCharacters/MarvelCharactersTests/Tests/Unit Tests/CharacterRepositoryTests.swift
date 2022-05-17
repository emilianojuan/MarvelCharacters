//
//  CharacterRepositoryTests.swift
//  MarvelCharactersTests
//
//  Created by Emiliano Galitiello on 16/05/2022.
//

import XCTest
import Combine

@testable import MarvelCharacters

class CharacterRepositoryTests: XCTestCase {

    var cancelable: AnyCancellable?

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
    }

    func testAPIReturnsError() throws {
        let mockError = MockError()
        let mockApiClient = MockMarvelAPIClient { _, _, _ in
            Fail(outputType: CharacterDataWrapperResponse.self, failure: MarvelAPIError.apiError(mockError)).eraseToAnyPublisher()
        }
        let repository = CharacterRepositoryImplementation(apiClient: mockApiClient)

        let expect = expectation(description: "the completion closure should be called")
        let notExpect = expectation(description: "should not be called")
        notExpect.isInverted = true
        cancelable = repository.fetchCharacters(pageNumber: 1, pageSize: 1, nameStartsWith: nil).sink { completion in
            switch completion {
            case .failure(let error):
                XCTAssert(error is MockError)
            default: break
            }

            expect.fulfill()
        } receiveValue: { _ in
            expect.fulfill()
        }
        wait(for: [expect, notExpect], timeout: 1)
    }

    func testAPIReturnsValue() throws {
        let mockApiClient = MockMarvelAPIClient { _, _, _ in
            Just(CharacterDataWrapperResponse(code: 200,
                                              status: "stat",
                                              copyright: nil,
                                              attributionText: nil,
                                              attributionHTML: nil,
                                              etag: nil,
                                              data: nil))
            .mapError { _ in
                MarvelAPIError.apiError(MockError())
            }.eraseToAnyPublisher()
        }
        let repository = CharacterRepositoryImplementation(apiClient: mockApiClient)

        let expectCompletion = expectation(description: "Completion gets called with finished result")
        let expectValue = expectation(description: "A value should be received")
        cancelable = repository.fetchCharacters(pageNumber: 1, pageSize: 1, nameStartsWith: nil).sink { completion in
            switch completion {
            case .finished:
                XCTAssertTrue(true, "Completion is finished")
            default: break
            }
            expectCompletion.fulfill()
        } receiveValue: { page in
            XCTAssertNotNil(page)
            expectValue.fulfill()
        }
        wait(for: [expectCompletion, expectValue], timeout: 5)
    }

    func testPageCalculations() {
        let mockApiClient = MockMarvelAPIClient { _, limit, offset in
            Just(CharacterDataWrapperResponse(code: 200,
                                              status: "stat",
                                              copyright: nil,
                                              attributionText: nil,
                                              attributionHTML: nil,
                                              etag: nil,
                                              data: CharacterDataContainerResponse(offset: offset,
                                                                                   limit: limit,
                                                                                   total: 1562,
                                                                                   count: 1,
                                                                                   results: [])))
            .mapError { _ in
                MarvelAPIError.apiError(MockError())
            }.eraseToAnyPublisher()
        }
        let repository = CharacterRepositoryImplementation(apiClient: mockApiClient)

        let expectCompletion = expectation(description: "Completion gets called with finished result")
        let expectValue = expectation(description: "A value should be received")
        cancelable = repository.fetchCharacters(pageNumber: 1, pageSize: 96, nameStartsWith: nil).sink { completion in
            switch completion {
            case .finished:
                expectCompletion.fulfill()
            default: break
            }
        } receiveValue: { page in
            XCTAssertEqual(17, page.totalPages)
            expectValue.fulfill()
        }
        wait(for: [expectCompletion, expectValue], timeout: 2)
    }

    func testCharacterMapping() {
        let mockApiClient = MockMarvelAPIClient { _, limit, offset in
            let characterResponse = CharacterResponse(id: 1,
                                                      name: "name",
                                                      description: "desc",
                                                      modified: nil,
                                                      resourceURI: "resourceURI",
                                                      urls: [
                                                        UrlResponse(type: UrlResponseType.comiclink,
                                                                    url: "comic"),
                                                        UrlResponse(type: UrlResponseType.detail,
                                                                    url: "detail"),
                                                        UrlResponse(type: UrlResponseType.wiki,
                                                                    url: "wiki")

                                                      ], thumbnail: ImageResponse(path: "path", fileExtension: "extension"),
                                                      comics: MediaListResponse(available: 10,
                                                                                returned: 10,
                                                                                collectionURI: "collectionURI",
                                                                                items: nil),
                                                      stories: MediaListResponse(available: 11,
                                                                                 returned: 11,
                                                                                 collectionURI: "collectionURI",
                                                                                 items: nil),
                                                      events: MediaListResponse(available: 12,
                                                                                returned: 12,
                                                                                collectionURI: "collectionURI",
                                                                                items: nil),
                                                      series: MediaListResponse(available: 13,
                                                                                returned: 13,
                                                                                collectionURI: "collectionURI",
                                                                                items: nil))
            return Just(CharacterDataWrapperResponse(code: 200,
                                                     status: "stat",
                                                     copyright: nil,
                                                     attributionText: nil,
                                                     attributionHTML: nil,
                                                     etag: nil,
                                                     data: CharacterDataContainerResponse(offset: offset,
                                                                                          limit: limit,
                                                                                          total: 1562,
                                                                                          count: 1,
                                                                                          results: [
                                                                                            characterResponse
                                                                                          ])))
            .mapError { _ in
                MarvelAPIError.apiError(MockError())
            }.eraseToAnyPublisher()
        }
        let repository = CharacterRepositoryImplementation(apiClient: mockApiClient)

        let expectValue = expectation(description: "A value should be received")
        cancelable = repository.fetchCharacters(pageNumber: 1, pageSize: 96, nameStartsWith: nil).sink { _ in

        } receiveValue: { page in
            guard let character = page.characters.first else {
                XCTFail("There should be a character")
                return
            }
            XCTAssertEqual(character.id, 1)
            XCTAssertEqual(character.name, "name")
            XCTAssertEqual(character.description, "desc")
            XCTAssertEqual(character.detailLinkURL, "detail")
            XCTAssertEqual(character.wikiLinkURL, "wiki")
            XCTAssertEqual(character.comicLinkURL, "comic")
            XCTAssertEqual(character.thumbnailURL, "path.extension")
            XCTAssertEqual(character.comicsCount, 10)
            XCTAssertEqual(character.storiesCount, 11)
            XCTAssertEqual(character.eventsCount, 12)
            XCTAssertEqual(character.seriesCount, 13)
            expectValue.fulfill()
        }
        wait(for: [expectValue], timeout: 2)
    }
}
