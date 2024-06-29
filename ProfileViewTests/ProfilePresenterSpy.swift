//
//  ProfilePresenterSpy.swift
//  ProfileViewTests
//
//  Created by Мария Шагина on 26.06.2024.
//

import Foundation
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    var profileService: ProfileServiceProtocol
    var profileImageService: ProfileImageServiceProtocol
    
    init(profileService: ProfileServiceProtocol = ProfileServiceStub(), profileImageService: ProfileImageServiceProtocol = ProfileImageServiceStub()) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    var updateProfileDataCalled = false
    
    func updateProfileData() {
        updateProfileDataCalled = true
    }
    
    func logoutFromProfile() { }
}
