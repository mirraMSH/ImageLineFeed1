//
//  ProfileServiceStub.swift
//  ProfileViewTests
//
//  Created by Мария Шагина on 26.06.2024.
//

import Foundation

import Foundation
@testable import ImageFeed

final class ProfileServiceStub: ProfileServiceProtocol {
    var profile: ImageFeed.ProfileResult?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ImageFeed.ProfileResult, Error>) -> Void) { }
}
