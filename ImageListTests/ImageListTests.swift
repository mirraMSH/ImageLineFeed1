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
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenter()
        let imagesListService = ImagesListServiceStub()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.imagesListService = imagesListService
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(imagesListService.photosNextPageCalled)
        XCTAssertEqual(imagesListService.photos.count, 1)
        XCTAssertEqual(imagesListService.photos[0].thumbImageURL, "thumb")
    }
    
    func testPresenterCallsSetupLike() throws {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        let cell = ImagesListCell()
        
        //when
        presenter.imageListCellDidTapLike(cell)
        
        //then
        XCTAssertTrue(viewController.setupLikeCalled)
    }
    
}
