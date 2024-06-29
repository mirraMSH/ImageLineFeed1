//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Мария Шагина on 23.06.2024.
//

import UIKit
import WebKit

final class ProfileLogoutService {
    
    static let shared = ProfileLogoutService()
    private init() { }
    
    func logout() {
        cleanCookies()
        cleanProfileData()
        cleanProfileImage()
        cleanImageList()
        switchToSplashViewController()
    }
    
    func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
    
    private func cleanProfileData() {
        ProfileService.shared.cleanProfile()
    }
    
    private func cleanProfileImage() {
        ProfileImageService.shared.cleanAvatar()
        OAuth2TokenStorage().cleanToken()
    }
    
    private func cleanImageList() {
        ImagesListService.shared.cleanPhotos()
    }
    
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

