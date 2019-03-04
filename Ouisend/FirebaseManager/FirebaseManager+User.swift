//
//  FirebaseManager+User.swift
//  Ouisend
//
//  Created by Esso Awesso on 23/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

extension FirebaseManager {
    
    /// Add user to the database, FIRUser used only for authentification
    ///
    /// - Parameters:
    ///   - user: the user to add to the database
    ///   - success: closure called when the user created with success
    ///   - failure: closure called when error happaned during the operation
    func createUser(_ user: User?, success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        guard let user = user else {
            let error = NSError(domain: "user equal to nil", code: 30000, userInfo: nil)
            failure?(error)
            return
        }
        
        let newUser = [
            "name": user.displayName ?? "",
            "createdAt": ServerValue.timestamp(),
            "updatedAt": ServerValue.timestamp(),
            "email": user.providerData[0].email ?? "",
            "profilePicture": [
                "name": user.displayName,
                "relativePath": "",
                "url": user.photoURL?.absoluteString ?? "" ]
            ] as [String: Any]
        usersReference.child(user.uid).setValue(newUser) { (error, reference) in
            error == nil ? success?() :  failure?(error)
        }
    }
    
    /// Create a new user in database
    ///
    /// - Parameter User: Firebase User and displayName
    
    func createUser(_ user: User?, displayName: String,  success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        guard let user = user else {
            let error = NSError(domain: "user equal to nil", code: 30000, userInfo: nil)
            failure?(error)
            return
        }
        
        let changeRequest = user.createProfileChangeRequest()
        
        changeRequest.displayName = displayName
        changeRequest.commitChanges { error in
            if let error = error {
                failure?(error)
            } else {
                // Profile updated.
                
                let newUser = [
                    "name": displayName,
                    "createdAt": ServerValue.timestamp(),
                    "updatedAt": ServerValue.timestamp(),
                    "profilePicture": [
                        "name": displayName,
                        "relativePath": "",
                        "url": user.photoURL?.absoluteString ?? "" ]
                    ] as [String: Any]
                self.usersReference.child(user.uid).setValue(newUser) { (error, reference) in
                    error == nil ? success?() :  failure?(error)
                }
            }
        }
    }
    
    
    /// Check if User with identifier exist in database
    ///
    /// - Parameter identifier: the identifier
    func existUser(_ user: User, completion: @escaping ((Bool) -> Void)) {
        usersReference.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.value as? [String: Any]) != nil {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    /// Get User by identifier
    ///
    /// - Parameter identifier: the identifier
    func user(with identifier: String, success: @escaping ((Birder) -> Void), failure: ((Error?) -> Void)?) {
        usersReference.child(identifier).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let user = Birder(identifier: snapshot.key, dictionary: dictionary)
                success(user)
            } else {
                failure?(nil)
            }
        })
    }
    
    
    /// Get All Users. This method should be used with caution as it will load large amount of data
    ///
    /// - Parameters:
    ///   - success: Success Getting Users List
    ///   - failure: Failed trying to get users list
    func users(with success: @escaping (([Birder]) -> Void), failure: ((Error?) -> Void)?) {
        usersReference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let currentUser = self.currentUser
                else {
                    let anError = NSError(domain: "No user logged", code: 30001, userInfo: nil)
                    failure?(anError)
                    return
            }
            guard let dictionary = snapshot.value as? [String: Any] else {
                let anError = NSError(domain: "error occured: can't retreive users", code: 30001, userInfo: nil)
                failure?(anError)
                return
            }
            var users = [Birder]()
            for (key, item) in dictionary {
                if key == currentUser.uid {
                    continue
                }
                if let dict = item as? [String: Any] {
                    let user = Birder(identifier: key, dictionary: dict)
                    users.append(user)
                }
            }
            success(users)
        })
    }

    

    func signoutUser() {
        try? Auth.auth().signOut()
        guard let currentUser = currentUser else { return }
    }
}
