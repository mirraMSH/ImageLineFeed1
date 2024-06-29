//
//  Constants.swift
//  ImageFeed
//
//  Created by Мария Шагина on 26.02.2024.
//

import Foundation

enum Constants {
    
    //     высока вероятность того, что у меня больше нет запросов на старые ключи, поэтому здесь прилагаю новые (старые ключи закомментированы)
    
    //    static let accessKey = "SY4PRl8nSlOVvHCHcJ_JEkJvm9OYnlA_zjMlJfkXM1k"
    //    static let secretKey = "-8zQN7XZfmlU5k4395ig6cZlS41z23a_i2wUbVMY1kE"
    static let accessKey = "E0IHLO11qpfBLhXeqW7aPkZsXgyrGN1to1cKwP_W3hI"
    static let secretKey = "90S7iNwQC9NzuKIuoBqtXcmEhm_qK_KTnBuga9Mcfrg"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
    
    struct AuthConfiguration {
        let accessKey: String
        let secretKey: String
        let redirectURI: String
        let accessScope: String
        let defaultBaseURL: URL
        let authURLString: String
        
        init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
            self.accessKey = accessKey
            self.secretKey = secretKey
            self.redirectURI = redirectURI
            self.accessScope = accessScope
            self.defaultBaseURL = defaultBaseURL
            self.authURLString = authURLString
        }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
}
