//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Мария Шагина on 26.06.2024.
//

import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    var profileService: ProfileServiceProtocol { get }
    var profileImageService: ProfileImageServiceProtocol { get }
    
    func updateProfileData()
    func logoutFromProfile()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    // MARK: - Public Properties
    weak var view: ProfileViewControllerProtocol?
    var profileService: ProfileServiceProtocol
    var profileImageService: ProfileImageServiceProtocol
    
    // MARK: - Private Properties
    private let profileLogoutService = ProfileLogoutService.shared
    private var oauth2TokenStorage = OAuth2TokenStorage()
    private var splashViewController = SplashViewController()
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(profileService: ProfileServiceProtocol = ProfileService.shared, profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    // MARK: - Public Methods
    
    func updateProfileData() {
        observeProfileImageService()
        updateProfileDetails()
        updateAvatar()
    }
    
    func logoutFromProfile() {
        profileLogoutService.logout()
        profileLogoutService.switchToSplashViewController()
    }
    // MARK: - Private Methods
    private func observeProfileImageService() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        view?.setupProfileDetails(profile: profile)
    }
    
    @objc private func updateAvatar() {
        guard
            let profileImageURL = self.profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.setupAvatar(with: url)
    }
}
