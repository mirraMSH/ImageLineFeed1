//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Мария Шагина on 16.06.2024.
//

import UIKit

final class AlertPresenter {
    func showAlert(in vc: UIViewController, with model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: model.completion)
        
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    
    func showAlertTwoButtons(in vc: UIViewController, with model: AlertModelTwoButtons) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let firstAction = UIAlertAction(
            title: model.firstButtonText,
            style: .default,
            handler: { _ in model.firstAction()})
        
        let secondAction = UIAlertAction(
            title: model.secondButtonText,
            style: .default,
            handler: { _ in model.secondAction()})
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        vc.present(alert, animated: true)
    }
}


/*func showAlert() {
       let alert = UIAlertController(
           title: "Что-то пошло не так",
           message: "Не удалось поставить лайк",
           preferredStyle: .alert
       )
       
       let action = UIAlertAction(
           title: "OK",
           style: .default)
       
       alert.addAction(action)
       present(alert, animated: true)
       
   }*/
