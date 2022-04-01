//
//  AppDelegate+Reign.swift
//  ReignTest
//
//  Created by Pedro Valderrama on 31/03/2022.
//

import SwiftKeychainWrapper
import UIKit

extension AppDelegate {
 
    func clearKeychainIfWillUnistall() {
        let freshInstall = !UserDefaults.standard.bool(forKey: "alreadyInstalled")
        if freshInstall {
            KeychainWrapper.wipeKeychain()
//            KeychainWrapper.standard.removeKeys()
            UserDefaults.standard.set(true, forKey: "alreadyInstalled")
        }
    }

}
