//
//  ImageListTests.swift
//  ImageListTests
//
//  Created by Мария Шагина on 26.06.2024.
//
@testable import ImageFeed
import XCTest

final class ImageListTests: XCTestCase {
    
    func testPresenterCallsFetchNextPage() throws {
        
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenter()
        let imagesListService = ImagesListServiceStub()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.imagesListService = imagesListService
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(imagesListService.photosNextPageCalled)
        XCTAssertEqual(imagesListService.photos.count, 1)
        XCTAssertEqual(imagesListService.photos[0].thumbImageURL, "thumb")
    }
    
    func testPresenterCallsSetupLike() throws {
        
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        let cell = ImagesListCell()
        
        presenter.imageListCellDidTapLike(cell)
        
        XCTAssertTrue(viewController.setupLikeCalled)
    }
}
