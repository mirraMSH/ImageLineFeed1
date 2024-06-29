//
//  ImagesListServiceStub.swift
//  ImageListTests
//
//  Created by Мария Шагина on 26.06.2024.
//

@testable import ImageFeed
import Foundation

final class ImagesListServiceStub: ImagesListServiceProtocol {
    var photos: [Photo] = [Photo(result: PhotoResult(
        id: "0",
        width: 1.1,
        height: 0.0,
        createdAt: "1 января 2000",
        description: "test",
        likedByUser: false,
        urls: .init(
            full: "full",
            thumb: "thumb"))
    )]
    
    var photosNextPageCalled = false
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], any Error>) -> Void) {
        photosNextPageCalled = true
    }
    
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Result<Void, any Error>) -> Void) { }
}
