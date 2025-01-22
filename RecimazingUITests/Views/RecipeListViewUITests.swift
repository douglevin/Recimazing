//
//  RecipeListViewUITests.swift
//  Recimazing
//
//  Created by Doug Levin on 1/21/25.
//

import XCTest

final class RecipeListViewUITests: XCTestCase {
    let app = XCUIApplication()
    let timeout = 5.0
    let cuisine = "American Cuisine".uppercased()
    let recipeName = "Banana Pancakes"
    let displayName = "Recimazing"
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testNavigationBarExists() throws {
        let navigationBar = app.navigationBars[displayName]
        XCTAssertTrue(navigationBar.exists)
    }
    
    func testRefreshButtonExists() throws {
        let refreshButton = app.buttons[AccessibilityIdentifiers.RecipeListView.refreshButton.description]
        XCTAssertTrue(refreshButton.exists)
    }
    
    func testListExists() throws {
        let recipeList = app.collectionViews[AccessibilityIdentifiers.RecipeListView.list.description]
        XCTAssertTrue(recipeList.waitForExistence(timeout: timeout))
    }
    
    func testSectionHeaderExists() throws {
        let recipeList = app.collectionViews[AccessibilityIdentifiers.RecipeListView.list.description]
        let sectionHeader = recipeList.staticTexts[cuisine]
        XCTAssertTrue(sectionHeader.waitForExistence(timeout: timeout))
    }
    
    func testRowExists() throws {
        let recipeList = app.collectionViews[AccessibilityIdentifiers.RecipeListView.list.description]
        let row = recipeList.buttons[recipeName]
        XCTAssertTrue(row.waitForExistence(timeout: timeout))
    }
    
    func testRowSelected() throws {
        let row = app.buttons[recipeName]
        row.tap()
        
        let recipeDetailView = app.scrollViews[AccessibilityIdentifiers.RecipeDetailView.scrollView.description]
        XCTAssertTrue(recipeDetailView.waitForExistence(timeout: timeout))
    }
}
