//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Мария Шагина on 15.03.2024.
//

import Foundation
import WebKit

protocol ProfileServiceProtocol {
    
    var profile: ProfileResult? { get }
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void)
}

// MARK: - Profile Service Models

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}

struct Profile {
    let username: String?
    let name: String?
    let loginName: String?
    let bio: String?
    
    init(profile: ProfileResult) {
        self.username = profile.username
        self.name = profile.firstName + " " + (profile.lastName ?? "")
        self.loginName = "@" + (profile.username)
        self.bio = profile.bio
    }
}

final class ProfileService: ProfileServiceProtocol {
    
    static let shared = ProfileService()
    private init() { }
    
    // MARK: - Profile Service Properties
    private let urlSession = URLSession.shared
    private(set) var profile: ProfileResult?
    private var task: URLSessionTask?
    private var lastToken: String?
    
    // MARK: - Profile Service Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        
        task?.cancel()
        lastToken = token
        guard var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET") else {
            assertionFailure("Failed to make HTTP request")
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let profileResult):
                self.profile = profileResult
                completion(.success(profileResult))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastToken = nil
            }
        }
        self.task = task
        
        task.resume()
    }
    
    func cleanProfile() {
        profile = nil
        task?.cancel()
        task = nil
    }
}
