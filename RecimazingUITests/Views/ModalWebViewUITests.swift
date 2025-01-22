//
//  ModalWebViewUITests.swift
//  RecimazingUITests
//
//  Created by Doug Levin on 1/21/25.
//

import XCTest

final class ModalWebViewUITests: XCTestCase {
    let app = XCUIApplication()
    let timeout = 5.0
    let recipeName = "Banana Pancakes"
    let websiteTitle = "Banana pancakes recipe | Good Food"
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        
        let row = app.buttons[recipeName]
        row.tap()
        
        let scrollView = app.scrollViews[AccessibilityIdentifiers.RecipeDetailView.scrollView.description]
        XCTAssertTrue(scrollView.waitForExistence(timeout: timeout))
        
        let button = scrollView.buttons[AccessibilityIdentifiers.RecipeDetailView.websiteButton.description]
        XCTAssertTrue(button.exists)
        button.tap()
    }
    
    func testWebView() throws {
        
        let webView = app.webViews[AccessibilityIdentifiers.ModalWebView.webView.description]
        XCTAssertTrue(webView.waitForExistence(timeout: timeout))
        
        let navigationBar = app.navigationBars[recipeName]
        XCTAssertTrue(navigationBar.exists)
        
        let doneButton = app.buttons[AccessibilityIdentifiers.ModalWebView.doneButton.description]
        XCTAssertTrue(doneButton.exists)
        
        let title = webView.otherElements[websiteTitle]
        XCTAssertTrue(title.exists)
    }
    
    func testDoneButton() throws {
        
        let webView = app.webViews[AccessibilityIdentifiers.ModalWebView.webView.description]
        XCTAssertTrue(webView.waitForExistence(timeout: timeout))
        
        let doneButton = app.buttons[AccessibilityIdentifiers.ModalWebView.doneButton.description]
        XCTAssertTrue(doneButton.exists)
        doneButton.tap()
        
        let scrollView = app.scrollViews[AccessibilityIdentifiers.RecipeDetailView.scrollView.description]
        XCTAssertTrue(scrollView.waitForExistence(timeout: timeout))
    }
    
    func testSheetGrabberButton() throws {
        
        let webView = app.webViews[AccessibilityIdentifiers.ModalWebView.webView.description]
        XCTAssertTrue(webView.waitForExistence(timeout: timeout))
        
        let sheetGrabberButton = app.buttons["Sheet Grabber"]
        XCTAssertTrue(sheetGrabberButton.exists)
        sheetGrabberButton.swipeDown()
        
        let scrollView = app.scrollViews[AccessibilityIdentifiers.RecipeDetailView.scrollView.description]
        XCTAssertTrue(scrollView.waitForExistence(timeout: timeout))
    }
}
