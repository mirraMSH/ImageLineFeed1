//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Мария Шагина on 26.06.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UITEST"]
        app.launch()
    }
    
    func testAuth() throws {
        sleep(3)
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("") //ввести электронную почту для ввода
        webView.swipeUp()
        
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        
        passwordTextField.typeText("") //ввести пароль
        
        sleep(5)
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        sleep(5)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        
        sleep(3)
        let tablesQuery = app.tables
        sleep(3)
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        sleep(3)
        cell.swipeUp()
        
        sleep(3)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        sleep(5)
        cellToLike.buttons["LikeButton"].tap()
        sleep(5)
        cellToLike.buttons["LikeButton"].tap()
        
        sleep(5)
        
        cellToLike.tap()
        
        sleep(5)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        sleep(5)
        
        image.pinch(withScale: 3, velocity: 1) // zoom in
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["backButtonWhite"]
        navBackButtonWhiteButton.tap()
        sleep (5)
    }
    
    func testProfile() throws {
        sleep(5)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["NameLSurnameLabel"].exists)
        XCTAssertTrue(app.staticTexts["@username"].exists)
        app.buttons["Exit"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
