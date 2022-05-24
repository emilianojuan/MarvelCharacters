//
//  MarvelCharactersUITests.swift
//  MarvelCharactersUITests
//
//  Created by Emiliano Galitiello on 11/05/2022.
//

import XCTest
@testable import MarvelCharacters

class MarvelCharactersUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {
    }

    /**
        Test: Open Character Detail
        - given: search text is "Iron Man"
        - when: tap on first result cell
        - then: Iron Main detail is shown
        
        Use keyboard shortcut COMMAND + SHIFT + K while simulator has focus on text input
     */
    func testOpenCharacterDetails_givenSearchIronma_whenTapOnFirstResultCell_thenCharacterDetailsViewOpensWithIronmanDetails() {

        let app = XCUIApplication()

        let searchText = "iron man"
        app.searchFields[AccessibilityIdentifier.searchTextField].tap()
        _ = app.searchFields[AccessibilityIdentifier.searchTextField].waitForExistence(timeout: 10)
        app.searchFields[AccessibilityIdentifier.searchTextField].typeText(searchText)
        app.buttons["search"].tap()
        app.screenshot()
        app.collectionViews.cells.firstMatch.tap()

        XCTAssertTrue(app.otherElements[AccessibilityIdentifier.characterDetailView].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Iron Man"].waitForExistence(timeout: 5))
        app.screenshot()
    }

    /**
        Test: Append second page
        - given: the application has loaded the first page
        - when: the user scrolls to the bottom
        - then: a second page is appended to the results
     */
    func testAppendsPage_givenFirstPageLoaded_whenScrollToBottom_thenASecondPageIsAppended() {

        let app = XCUIApplication()

        let secondPageResultText = app.staticTexts["Showing 192 of 1562"]
        while !secondPageResultText.exists {
            app.swipeUp(velocity: XCUIGestureVelocity.fast)
        }
        XCTAssertTrue(app.staticTexts["Showing 192 of 1562"].waitForExistence(timeout: 10))
    }
}
