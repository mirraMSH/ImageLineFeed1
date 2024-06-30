//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Мария Шагина on 08.06.2024.
//

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void)
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListService: ImagesListServiceProtocol {
    
    static let shared = ImagesListService()
    init() { }
    
    // MARK: - ImagesListService Properties
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var pageNumber: Int = 1
    private var task: URLSessionTask?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let oAuthTokenStorage = OAuth2TokenStorage()
    private let perPage: Int = 10
    private let urlSession = URLSession.shared
    
    // MARK: - ImagesListService Methods
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil { return }
        task?.cancel()
        
        guard var request = URLRequest.makeHTTPRequest(path: "/photos?page=\(pageNumber)&per_page=\(perPage)", httpMethod: "GET", baseURL: Constants.defaultBaseURL),
              let token = oAuthTokenStorage.token else {
            assertionFailure("Failed to make HTTP request in ImageListService URL Method")
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result:Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            self.task = nil
            
            switch result {
            case .success(let photoResults):
                self.photos.append(contentsOf: photoResults.map { Photo(result: $0) })
                completion(.success(self.photos))
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                object: self,
                                                userInfo: ["Photos": self.photos])
                self.pageNumber += 1
            case .failure(let error):
                print("[objectTask] - fetchPhotosNextPage: ImagesListService - \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        guard let request = isLikedPhotosRequest(photoId: photoId, isLiked: isLiked) else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success:
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    self.photos[index].isLiked = isLiked
                }
                completion(.success(()))
            case .failure(let error):
                print("[objectTask - ChangeLike]: ImagesListService - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func isLikedPhotosRequest(photoId: String, isLiked: Bool) -> URLRequest? {
        let method = isLiked ? "POST" : "DELETE"
        var request = URLRequest.makeHTTPRequest(
            path: "/photos"
            + "/\(photoId)"
            + "/like",
            httpMethod: method
        )
        guard let token = oAuthTokenStorage.token else {
            assertionFailure("Failed to make HTTP request in ImageListService URL Method")
            return nil}
        
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func cleanPhotos() {
        photos = []
        lastLoadedPage = nil
        task?.cancel()
    }
}

