//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Мария Шагина on 21.04.2024.
//

import Foundation

// MARK: - Profile Image Models

protocol ProfileImageServiceProtocol {
    var avatarURL: String? { get }
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void)
}

struct UserResult: Codable {
    var profileImage: ProfileImage
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}

final class ProfileImageService: ProfileImageServiceProtocol {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private init() { }
    
    // MARK: - Profile Image Properties
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let oAuthTokenStorage = OAuth2TokenStorage()
    
    // MARK: - Profile Image Methods
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET"),
              let token = oAuthTokenStorage.token else {
            assertionFailure("Failed to make HTTP request in Profile Image URL Method")
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result:Result<UserResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let user):
                completion(.success(user.profileImage.large))
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                                object: self,
                                                userInfo: ["URL": user.profileImage.large])
                self.avatarURL = user.profileImage.large
            case .failure(let error):
                print("[objectTask]: Profile Image Service - \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func cleanAvatar() {
        avatarURL = nil
        task?.cancel()
        task = nil
    }
}
