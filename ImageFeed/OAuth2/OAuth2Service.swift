//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Мария Шагина on 02.03.2024.
//

import UIKit

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() { }
    
    private let urlSession = URLSession.shared
    
    private var lastCode: String?
    private var task: URLSessionTask?
    private var oauth2TokenStorage = OAuth2TokenStorage()
    
    private var authToken: String? {
        get {
            return oauth2TokenStorage.token
        }
        set {
            oauth2TokenStorage.token = newValue
        }
    }
    
    enum AuthServiceError: Error {
        case invalidRequest
    }
    
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code{
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        
        lastCode = code
        guard let request = self.makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseBody):
                    let token = responseBody.accessToken
                    self?.authToken = token
                    completion(.success(responseBody))
                case .failure(let error):
                    completion(.failure(error))
                }
                self?.task = nil
                self?.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}


extension OAuth2Service {
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            assertionFailure("Unable to construct Base URL")
            return nil
        }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            preconditionFailure("Unable to construct Token URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}







