//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Мария Шагина on 03.03.2024.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let alert = AlertPresenter()
    
    
    //MARK: - Splash Image Launch Logo
    private var splashImage: UIImageView = {
        let image = UIImage(named: "splash_screen_logo")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    //MARK: - Splash Viev Controller Main Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        setupViews()
        setupLaunchLogoConstraints()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            fetchProfile(token: token)
        } else {
            switchToAuthViewController()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        
        present(authViewController, animated: true)
    }
    
    private func setupViews() {
        view.addSubview(splashImage)
    }
    
    private func setupLaunchLogoConstraints() {
        NSLayoutConstraint.activate([
            splashImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        fetchOAuthToken(code)
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                fetchProfile(token: token.accessToken)
            case .failure:
                print("Failed to fetch OAuth Token")
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success (let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { [weak self] _ in 
                    self?.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                }
                
            case .failure (let error):
                print("Ошибка загрузки профиля: \(error)")
                UIBlockingProgressHUD.dismiss()
                self.alert.showAlert(in: self, with: AlertModel(
                    title: "Что-то пошло не так",
                    message: "Ошибка загрузки профиля",
                    buttonText: "OK",
                    completion:  nil))
            }
        }
    }
}
