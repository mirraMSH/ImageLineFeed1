//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Мария Шагина on 23.02.2024.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: - ImagesListCell Properties
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"
    // MARK: - ImagesListCell Outlets
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
    // MARK: - ImagesListCell Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.imageView?.image = likeImage
        likeButton.setImage(likeImage, for: .normal)
    }
    
}
