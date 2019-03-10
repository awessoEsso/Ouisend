//
//  FirebaseManager+Token.swift
//  Ouisend
//
//  Created by Esso Awesso on 06/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseInstanceID

extension FirebaseManager {
    func saveToken(_ token: String) {
        // save token  in UserDefaults
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "token")
        guard let currentUser = self.currentUser
            else {
                let anError = NSError(domain: "No user logged", code: 30001, userInfo: nil)
                print(anError)
                return
        }
        let reference = tokenReference.child(currentUser.uid)
        let newToken = [
            "createdAt": ServerValue.timestamp(),
            "registrationToken": token,
            "updatedAt": ServerValue.timestamp()
            ] as [String: Any]
        reference.setValue(newToken)
        
    }
    
    func tokenForUser(with identifier: String, success: @escaping ((String) -> Void), failure: ((Error?) -> Void)?) {
        tokenReference.child(identifier).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                if let token = dictionary["registrationToken"] as? String {
                    success(token)
                }
                else {
                    failure?(nil)
                }
            } else {
                failure?(nil)
            }
        })
    }
    
}
