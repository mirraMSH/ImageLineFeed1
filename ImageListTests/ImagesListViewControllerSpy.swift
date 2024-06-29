//
//  ImagesListViewControllerSpy.swift
//  ImageListTests
//
//  Created by Мария Шагина on 26.06.2024.
//

import Foundation
@testable import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol!
    
    var setupLikeCalled = false
    
    func updateTableViewAnimated() { }
    
    func setupLike(for cell: ImagesListCell) {
        setupLikeCalled = true
    }
}
