//
//  CharactersResponseTests.swift
//  MarvelCharactersTests
//
//  Created by Emiliano Galitiello on 15/05/2022.
//

import XCTest
@testable import MarvelCharacters

class CharactersResponseTests: XCTestCase {

    var data: Data!

    override func setUpWithError() throws {
        continueAfterFailure = false
        guard let stringData = Bundle(for: type(of: self)).path(forResource: "characters_response", ofType: "json") else {
            fatalError()
        }
        data = try String(contentsOfFile: stringData).data(using: .utf8)
    }

    override func tearDownWithError() throws {
        data = nil
    }

    func testResponseParsesCorrectly() throws {
        var characterDataWrapperResponse: CharacterDataWrapperResponse?

        do {
            characterDataWrapperResponse = try JSONDecoder().decode(CharacterDataWrapperResponse.self, from: data)
        } catch {
            XCTFail("Error decoding CharacterDataWrapperResponse")
        }

        XCTAssertEqual(200, characterDataWrapperResponse?.code)
        XCTAssertEqual("Ok", characterDataWrapperResponse?.status)
        XCTAssertNotNil(characterDataWrapperResponse?.data)

        guard let characterDataContainerResponse = characterDataWrapperResponse?.data else {
            XCTFail("Error decoding CharacterDataContainerResponse")
            return
        }

        XCTAssertEqual(100, characterDataContainerResponse.limit)
        XCTAssertEqual(0, characterDataContainerResponse.offset)
        XCTAssertEqual(1562, characterDataContainerResponse.total)
        XCTAssertEqual(100, characterDataContainerResponse.count)
        XCTAssertNotNil(characterDataContainerResponse.results)
        XCTAssertEqual(100, characterDataContainerResponse.results?.count)

        guard let characterResponse = characterDataContainerResponse.results?.first else {
            XCTFail("Error decoding CharacterResponse")
            return
        }

        XCTAssertEqual(1011334, characterResponse.id)
        XCTAssertEqual("3-D Man", characterResponse.name)
        XCTAssertEqual("", characterResponse.description)
        XCTAssertEqual("2014-04-29T14:18:17-0400", characterResponse.modified)
        XCTAssertEqual("http://gateway.marvel.com/v1/public/characters/1011334", characterResponse.resourceURI)
        XCTAssertEqual(12, characterResponse.comics?.available)
        XCTAssertEqual(3, characterResponse.series?.available)
        XCTAssertEqual(21, characterResponse.stories?.available)
        XCTAssertEqual(1, characterResponse.events?.available)
        XCTAssertEqual(3, characterResponse.urls?.count)
        XCTAssertEqual("http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", characterResponse.thumbnail?.path)
        XCTAssertEqual("jpg", characterResponse.thumbnail?.fileExtension)
    }
}
