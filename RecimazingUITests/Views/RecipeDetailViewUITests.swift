//
//  RecipeDetailViewUITests.swift
//  RecimazingUITests
//
//  Created by Doug Levin on 1/21/25.
//

import XCTest

final class RecipeDetailViewUITests: XCTestCase {
    let app = XCUIApplication()
    let timeout = 5.0
    let cuisine = "American Cuisine"
    let recipeName = "Banana Pancakes"
    let displayName = "Recimazing"
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        
        let row = app.buttons[recipeName]
        row.tap()
    }
    
    func testElementsExist() throws {
        let scrollView = app.scrollViews[AccessibilityIdentifiers.RecipeDetailView.scrollView.description]
        XCTAssertTrue(scrollView.waitForExistence(timeout: timeout))
        
        let backButton = app.buttons[displayName]
        XCTAssertTrue(backButton.exists)
        
        let cuisine = scrollView.staticTexts[cuisine]
        XCTAssertTrue(cuisine.exists)
        
        let name = scrollView.staticTexts[recipeName]
        XCTAssertTrue(name.exists)
        
        let image = scrollView.images.firstMatch
        XCTAssertTrue(image.exists)
        
        let websiteButton = scrollView.buttons[AccessibilityIdentifiers.RecipeDetailView.websiteButton.description]
        XCTAssertTrue(websiteButton.exists)
        
        let videoButton = scrollView.buttons[AccessibilityIdentifiers.RecipeDetailView.videoButton.description]
        XCTAssertTrue(videoButton.exists)
    }
        
    func testBackButton() {
        let scrollView = app.scrollViews[AccessibilityIdentifiers.RecipeDetailView.scrollView.description]
        XCTAssertTrue(scrollView.waitForExistence(timeout: timeout))
        
        let backButton = app.buttons[displayName]
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        let recipeList = app.collectionViews[AccessibilityIdentifiers.RecipeListView.list.description]
        XCTAssertTrue(recipeList.waitForExistence(timeout: timeout))
    }
    
    func testWebsiteButton() {
        let scrollView = app.scrollViews[AccessibilityIdentifiers.RecipeDetailView.scrollView.description]
        XCTAssertTrue(scrollView.waitForExistence(timeout: timeout))
        
        let button = scrollView.buttons[AccessibilityIdentifiers.RecipeDetailView.websiteButton.description]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let webView = app.webViews[AccessibilityIdentifiers.ModalWebView.webView.description]
        XCTAssertTrue(webView.waitForExistence(timeout: timeout))
    }
    
    func testVideoButton() {
        let scrollView = app.scrollViews[AccessibilityIdentifiers.RecipeDetailView.scrollView.description]
        XCTAssertTrue(scrollView.waitForExistence(timeout: timeout))
        
        let button = scrollView.buttons[AccessibilityIdentifiers.RecipeDetailView.videoButton.description]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let webView = app.webViews[AccessibilityIdentifiers.ModalWebView.webView.description]
        XCTAssertTrue(webView.waitForExistence(timeout: timeout))
    }
}
