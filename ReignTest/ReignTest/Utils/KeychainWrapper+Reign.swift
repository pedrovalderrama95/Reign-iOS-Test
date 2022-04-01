//
//  KeychainWrapper+Reign.swift
//  ReignTest
//
//  Created by Pedro Valderrama on 31/03/2022.
//

import SwiftKeychainWrapper

extension KeychainWrapper.Key {
    static let lastNews: KeychainWrapper.Key = "lastNews"
    static let deletedNews: KeychainWrapper.Key = "deletedNews"
}

extension KeychainWrapper {
    func removeKeys() {
        remove(forKey: .lastNews)
        remove(forKey: .deletedNews)
    }
}
