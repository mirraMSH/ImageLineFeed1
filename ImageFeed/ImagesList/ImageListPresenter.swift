//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Мария Шагина on 25.06.2024.
//

import Foundation

protocol ImagesListPresenterProtocol {
var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    var imagesListService: ImagesListServiceProtocol { get }
    func viewDidLoad()
}

final class ImagesListPresenter: ImagesListPresenterProtocol, ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        view?.setupLike(for: cell)
    }
    
    // MARK: - Public Properties
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var imagesListService: ImagesListServiceProtocol
    // MARK: - Private Properties
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared) {
        self.imagesListService = imagesListService
    }
    // MARK: - Public Methods
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                view?.updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage(completion: { _ in })
    }
}
