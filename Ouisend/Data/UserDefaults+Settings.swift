//
//  UserDefaults+Settings.swift
//  Ouisend
//
//  Created by Esso Awesso on 16/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let messagesKey = "OuiMessages"
    
    // MARK: - Mock Messages
    
    func setOuiMessages(count: Int) {
        set(count, forKey: "OuiMessages")
        synchronize()
    }
    
    func OuiMessagesCount() -> Int {
        if let value = object(forKey: "OuiMessages") as? Int {
            return value
        }
        return 20
    }
    
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBefore"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
