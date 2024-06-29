//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Мария Шагина on 02.03.2024.
//

import Foundation


enum ProfileError: Error {
    case failedToCreateRequest
    case networkError
    case decodingError
    case taskError
    case invalidResponce
    case noData
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = data(for: request) { (result: Result<Data, Error>) in
            
            switch result {
            case .success(let data):
                do {
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                    print("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                }
            case .failure(let error):
                completion(.failure(error))
                print("[dataTask]: DataError - \(error.localizedDescription)")
                
            }
        }
        return task
    }
    
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("[dataTask]: NetworkError - status code: \(statusCode)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("[dataTask]: NetworkError - \(error.localizedDescription)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("[dataTask]: NetworkError - \(String(describing: error?.localizedDescription))")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
}

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = Constants.defaultBaseURL
        
        
    ) -> URLRequest? {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            assertionFailure("Failed to make url")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
