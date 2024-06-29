//
//  ImagesListService Models.swift
//  ImageFeed
//
//  Created by Мария Шагина on 25.06.2024.
//

import Foundation

struct Photo {
    
    static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    init(result photo: PhotoResult) {
        self.id = photo.id
        self.size = CGSize(width: photo.width, height: photo.height)
        self.createdAt = Photo.dateFormatter.date(from: photo.createdAt ?? "")
        self.welcomeDescription = photo.description
        self.thumbImageURL = photo.urls?.thumb ?? ""
        self.largeImageURL = photo.urls?.full ?? ""
        self.isLiked = photo.likedByUser
    }
}

struct PhotoResult: Codable {
    let id: String
    let width: CGFloat
    let height: CGFloat
    let createdAt: String?
    let description: String?
    var likedByUser: Bool
    let urls: UrlsResult?
}

struct UrlsResult: Codable {
    let full: String?
    let thumb: String?
}

struct LikePhotoResult: Decodable {
    let photoId: PhotoResult?
}

