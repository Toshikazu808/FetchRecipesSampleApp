//
//  FetchTakeHomeProjectUITests.swift
//  FetchTakeHomeProjectUITests
//
//  Created by Ryan Kanno on 2/6/25.
//

import XCTest

@MainActor final class FetchTakeHomeProjectUITests: XCTestCase {
    func testNoResults() {
        // setup
        let app = XCUIApplication()
        continueAfterFailure = false
        app.launchArguments = ["-UITestsNoResults"]
        app.launch()
        
        // execute
        let noRecipes = app.staticTexts["NoRecipes"]
        XCTAssertTrue(noRecipes.exists)
    }
    
    func testHasResults() {
        // setup
        let app = XCUIApplication()
        continueAfterFailure = false
        app.launchArguments = ["-UITestsHasResults"]
        app.launch()
        
        // execute
        let hasRecipes = app.staticTexts["NoRecipes"]
        XCTAssertTrue(!hasRecipes.exists)
        
        let recipeName0 = app.staticTexts["RecipeName: 0"]
        let recipeCuisine0 = app.staticTexts["RecipeCuisine: 0"]
        let recipeName1 = app.staticTexts["RecipeName: 1"]
        let recipeCuisine1 = app.staticTexts["RecipeCuisine: 1"]
        
        // assert
        let t: TimeInterval = 2
        XCTAssertTrue(recipeName0.waitForExistence(timeout: t))
        XCTAssertTrue(recipeCuisine0.waitForExistence(timeout: t))
        XCTAssertTrue(recipeName1.waitForExistence(timeout: t))
        XCTAssertTrue(recipeCuisine1.waitForExistence(timeout: t))
    }
}
