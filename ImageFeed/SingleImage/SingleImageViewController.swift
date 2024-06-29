//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Мария Шагина on 24.02.2024.
//

import UIKit
import ProgressHUD
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - SingleImageViewController Outlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        let share = UIActivityViewController(
            activityItems: [image as Any],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    // MARK: - SingleImageViewController Properties
    var image: URL? {
        didSet {
            guard isViewLoaded else {return}
            setImage()
        }
    }
    
    private let alert = AlertPresenter()
    
    // MARK: - SingleImageViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        setImage()
    }
    
    private func setImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: image) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.alert.showAlertTwoButtons(in: self, with: AlertModelTwoButtons(
                    title: "Что-то пошло не так",
                    message: "Попробовать ещё раз?",
                    firstButtonText: "Не надо",
                    secondButtonText: "Повторить",
                    firstAction: { [weak self] in
                        guard let self = self else { return }
                        self.didTapBackButton()
                    },
                    secondAction: { [weak self] in
                        guard let self = self else { return }
                        setImage().self}
                ))
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}
// MARK: - SingleImageViewController Extension
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}


