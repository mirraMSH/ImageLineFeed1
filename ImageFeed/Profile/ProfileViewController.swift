//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Мария Шагина on 24.02.2024.
//

import UIKit
import Kingfisher
import WebKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol! { get set }
    func setupAvatar(with url: URL)
    func setupProfileDetails(profile: ProfileResult)
}

class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    
    // MARK: - Private Properties
    private let profileService = ProfileService.shared
    var presenter: ProfilePresenterProtocol! = ProfilePresenter()
    //    private var profileImageServiceObserver: NSObjectProtocol?
    //    private let oAuthTokenStorage = OAuth2TokenStorage()
    
    // MARK: - Profile Lebel Views
    private let avatarImageView: UIImageView = {
        let image = UIImage(named: "Photo")
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.accessibilityIdentifier = "NameLSurnameLabel"
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private let loginNameLabel: UILabel = {
        let loginNameLabel = UILabel()
        loginNameLabel.accessibilityIdentifier = "@username"
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = .ypGray
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return loginNameLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello World!"
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(named: "Exit")!, target: self, action: #selector(didTapLogoutButton))
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "logout button"
        return button
    }()
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.updateProfileData()
        setupViews()
        setupAllConstraints()
    }
    
    // MARK: - Public Properties
    func setupAvatar(with url: URL) {
        self.avatarImageView.kf.indicatorType = .activity
        self.avatarImageView.kf.setImage(with: url, placeholder: UIImage(named: "tab_profile_active"))
    }
    
    // MARK: - Private Properties
    
    private func setupViews() {
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logoutButton)
    }
    
    private func setupAllConstraints() {
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: loginNameLabel.trailingAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Logout Button
    
    @objc
    private func didTapLogoutButton() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Вы уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        let noButton = UIAlertAction(title: "Нет", style: .cancel)
        let yesButton = UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
            ProfileLogoutService.shared.logout()
        }
        
        alert.addAction(noButton)
        alert.addAction(yesButton)
        
        present(alert, animated: true)
    }
    func setupProfileDetails(profile: ProfileResult) {
        self.nameLabel.text = "\(profile.firstName) \(profile.lastName ?? "")"
        self.loginNameLabel.text = "@\(profile.username)"
        self.descriptionLabel.text = profile.bio
    }
}

// MARK: - Extentions

extension UIColor {
    static var ypRed: UIColor { UIColor(named: "YP Red (iOS)") ?? UIColor.red }
    static var ypBlack: UIColor { UIColor(named: "YP Black") ?? UIColor.black}
    static var ypBackground: UIColor { UIColor(named: "YP Background") ?? UIColor.darkGray }
    static var ypGray: UIColor { UIColor(named: "YP Gray") ?? UIColor.gray }
    static var ypWhite: UIColor { UIColor(named: "YP White") ?? UIColor.white}
}

