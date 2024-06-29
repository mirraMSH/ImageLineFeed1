//
//  ViewController.swift
//  ImageFeed
//
//  Created by Мария Шагина on 14.01.2024.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol! { get set }
    
    func updateTableViewAnimated()
    func setupLike(for cell: ImagesListCell)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    
    // MARK: - ImagesListViewController Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - ImagesListViewController Properties
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private let alert = AlertPresenter()
    var presenter: ImagesListPresenterProtocol! = ImagesListPresenter()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    // MARK: - ImagesListViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController else {return}
            guard let indexPath = sender as? IndexPath else {return}
            let photo = presenter.photos[indexPath.row]
            guard let imageURL = URL(string: photo.largeImageURL) else { return }
            viewController.image = imageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = presenter.photos.count
        let newCount = presenter.imagesListService.photos.count
        presenter.photos = presenter.imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    func setupLike(for cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = presenter.photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLiked: !photo.isLiked) { result in
            switch result {
            case .success:
                self.presenter.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: self.presenter.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.alert.showAlert(in: self, with: AlertModel(
                    title: "Что-то пошло не так",
                    message: "Не удалось поставить лайк",
                    buttonText: "OK",
                    completion:  nil))
            }
        }
    }
}

// MARK: - ImagesListViewController Extension
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let imageUrl = presenter.photos[indexPath.row].thumbImageURL
        let url = URL(string: imageUrl)
        let placeholder = UIImage(named: "Stub")
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: placeholder) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            cell.cellImage.kf.indicatorType = .none
        }
        if let date = imagesListService.photos[indexPath.row].createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }
        let isLiked = imagesListService.photos[indexPath.row].isLiked == false
        let likeImage = isLiked ? UIImage(named: "like_button_off") : UIImage(named: "like_button_on")
        cell.likeButton.setImage(likeImage, for: .normal)
        cell.selectionStyle = .none
    }
}

// MARK: - ImagesListViewController Data Source
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self.presenter as? ImagesListCellDelegate
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

// MARK: - ImagesListViewController UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter.imagesListService.photos.count && !ProcessInfo().arguments.contains("UITEST") {
            presenter.imagesListService.fetchPhotosNextPage(completion: { _ in })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = presenter.photos[indexPath.row].size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = presenter.photos[indexPath.row].size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
