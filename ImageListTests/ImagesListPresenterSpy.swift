//
//  ImagesListPresenterSpy.swift
//  ImageListTests
//
//  Created by Мария Шагина on 26.06.2024.
//

@testable import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var imagesListService: ImagesListServiceProtocol
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListServiceStub()) {
        self.imagesListService = imagesListService
    }
    
    var viewDidLoadCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
