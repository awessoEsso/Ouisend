//
//  Datas.swift
//  Ouisend
//
//  Created by Esso Awesso on 24/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation
import Firebase


class Datas {
    
    // MARK: Singleton
    static let shared = Datas()
    
    var cities: [City]!
    
    var birder: Birder?
    
    init() {
        
        DatasManager().getCities(success: { (cities) in
            self.cities = cities.sorted { $0.name ?? "" < $1.name ?? "" }
        }) { (error) in
            print(error?.localizedDescription ?? "Error loading cities")
        }
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let currentUser = user {
                FirebaseManager.shared.user(with: currentUser.uid, success: { (birder) in
                    self.birder = birder
                }, failure: { (error) in
                    print(error ?? "Error getting current birder")
                })
            }
            else {
                self.birder = nil
            }
        }
    }
    
    
}
