//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Мария Шагина on 02.03.2024.
//

import UIKit
import SwiftKeychainWrapper


final class OAuth2TokenStorage {
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "BearerToken")
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: "BearerToken")
            } else {
                KeychainWrapper.standard.removeObject(forKey: "BearerToken")
            }
        }
    }
    
    func cleanToken() {
        KeychainWrapper.standard.removeAllKeys()
    }
}
