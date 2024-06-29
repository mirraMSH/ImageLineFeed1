//
//  ProfileImageServiceStub.swift
//  ProfileViewTests
//
//  Created by Мария Шагина on 26.06.2024.
//

import Foundation
@testable import ImageFeed

final class ProfileImageServiceStub: ProfileImageServiceProtocol {
    
    var avatarURL: String? = "https://test.com"
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) { }
}
