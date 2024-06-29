//
//  AlertModels.swift
//  ImageFeed
//
//  Created by Мария Шагина on 25.06.2024.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> ())?
}

struct AlertModelTwoButtons {
    let title: String
    let message: String
    let firstButtonText: String
    let secondButtonText: String
    let firstAction: () -> Void
    let secondAction: () -> Void
}
