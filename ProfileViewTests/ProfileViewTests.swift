//
//  ProfileViewTests.swift
//  ProfileViewTests
//
//  Created by Мария Шагина on 26.06.2024.
//
@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsPresenterUpdateProfileData() throws {
        
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.updateProfileDataCalled)
    }
    
    func testSetupAvatarWithUpdateAvatarURL() throws {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(profileService: ProfileServiceStub(), profileImageService: ProfileImageServiceStub())
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.updateProfileData()
        
        XCTAssertTrue(viewController.setupAvatarCalled)
        XCTAssertEqual(viewController.presenter.profileImageService.avatarURL, "https://test.com")
    }
    
}
