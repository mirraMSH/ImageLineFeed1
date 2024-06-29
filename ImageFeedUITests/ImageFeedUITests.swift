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
        loginTextField.typeText("mirra.madarame@gmail.com") //ввести электронную почту для ввода
        webView.swipeUp()
        //        XCUIApplication().toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("QWE321qwe") //ввести пароль
        //        webView.swipeUp()
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        sleep(5)
        
//        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
    }
    
    func testFeed() throws {
        sleep(3)
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(3)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["LikeButton"].tap()
        sleep(5)
        cellToLike.buttons["LikeButton"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["backButtonWhite"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["NameLSurnameLabel"].exists) // ввести имя+фамилия
        XCTAssertTrue(app.staticTexts["@username"].exists) // ввести @логин
        
        app.buttons["Exit"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
