//
//  ProfileViewControllerSpy.swift
//  ProfileViewTests
//
//  Created by Мария Шагина on 26.06.2024.
//

import Foundation
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    func setupProfileDetails(profile: ImageFeed.ProfileResult) {
        setupProfileDetailsCalled = true
    }
    var views: Bool = false
    var constraints: Bool = false
    
    
    var presenter: ProfilePresenterProtocol!
    
    var setupAvatarCalled = false
    var setupProfileDetailsCalled = false
    
    func setupAvatar(with url: URL) {
        setupAvatarCalled = true
    }
}
