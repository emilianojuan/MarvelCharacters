//
//  MarvelCharactersTests.swift
//  MarvelCharactersTests
//
//  Created by Emiliano Galitiello on 11/05/2022.
//

import XCTest
@testable import MarvelCharacters

class MarvelCharactersTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let publicKey = String("35e7702de15c3238c6b5548323add2ca".reversed())
        print(publicKey)
        let privateKey = String("d706fc90ab8101a29b10e7e46c396000481ed001".reversed())
        print(privateKey)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
