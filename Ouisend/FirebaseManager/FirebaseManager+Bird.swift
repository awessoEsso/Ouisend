//
//  FirebaseManager+Bird.swift
//  Ouisend
//
//  Created by Esso Awesso on 24/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation
import Firebase
import SwiftDate

extension FirebaseManager {
    
    /// Add user to the database, FIRUser used only for authentification
    ///
    /// - Parameters:
    ///   - user: the user to add to the database
    ///   - success: closure called when the user created with success
    ///   - failure: closure called when error happaned during the operation
    func createBird(_ bird: Bird, success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        
        let birdReference = birdsReference.childByAutoId()
        
        let newBird = [
            "departureCity": bird.departureCity ,
            "departureCountry": bird.departureCountry ,
            "departureDate": bird.departureDate.timeIntervalSince1970 * 1000 ,
            "arrivalCity": bird.arrivalCity,
            "arrivalCountry": bird.arrivalCountry,
            "arrivalDate": bird.arrivalDate.timeIntervalSince1970 * 1000 ,
            "birdWeight": bird.birdWeight,
            "birdTotalPrice": bird.birdTotalPrice,
            "birdPricePerKilo": bird.birdPricePerKilo,
            "birderName": bird.birdTravelerName,
            "birderProfilePicUrl": bird.birderProfilePicUrl.absoluteString,
            "currency": bird.currency,
            "createdAt": ServerValue.timestamp()
            ] as [String : Any]
        
        birdReference.setValue(newBird) { (error, reference) in
            if (error == nil) {
                self.createBirdJoinReference(reference.key!, success: {
                    success?()
                }, failure: { (joinError) in
                    failure?(joinError)
                })
            }
            else {
                failure?(error)
            }
        }
    }
    
    /// Get User by identifier
    ///
    /// - Parameter identifier: the identifier
    func bird(with identifier: String, success: @escaping ((Bird) -> Void), failure: ((Error?) -> Void)?) {
        birdsReference.child(identifier).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let bird = Bird(identifier: snapshot.key, dictionary: dictionary)
                success(bird)
            } else {
                failure?(nil)
            }
        })
    }
    
    fileprivate func createBirdJoinReference(_ birdId: String , success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        if let currentUser = Auth.auth().currentUser {
            joinUsersReference.child(currentUser.uid).child("birds").child(birdId).setValue(ServerValue.timestamp()) { (error, reference) in
                if (error == nil) {
                    success?()
                }
                else {
                    failure?(error)
                }
            }
        }
        
    }
    
    func myBirds(_ success: @escaping (([Bird]) -> Void), failure: ((Error?) -> Void)?) {
        
        guard let currentUser = Auth.auth().currentUser else {
            let error = NSError(domain: "user not loggedIn", code: 3001, userInfo: nil)
            failure?(error)
            return
        }
        var birds = [Bird]()
        let userIdentifier = currentUser.uid
        joinUsersReference.child(userIdentifier).child("birds").queryOrderedByValue().observe(DataEventType.value, with: { (snapshot) in
            let taskEvent = DispatchGroup()
            taskEvent.enter()
            birds.removeAll()
            let dictionary = snapshot.value as? [String: Any]
            // for each identifier we get the event noeud
            dictionary?.forEach {
                taskEvent.enter()
                let birdIdentifier = $0.key
                self.bird(with: birdIdentifier, success: { (bird) in
                    if bird.departureDate > Date() {
                        birds.append(bird)
                    }
                    taskEvent.leave()
                }, failure: { (error) in
                    failure?(error)
                    taskEvent.leave()
                })
            }
            taskEvent.leave()
            taskEvent.notify(queue: .main, execute: {
                birds = birds.sorted(by: {$0.departureDate < $1.departureDate})
                success(birds)
            })
        })
    }
    
    func birds(with success: @escaping (([Bird]) -> Void), failure: ((Error?) -> Void)?) {
        birdsReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else {
                let anError = NSError(domain: "error occured: can't retreive cities", code: 30001, userInfo: nil)
                failure?(anError)
                return
            }
            var birds = [Bird]()
            for (key, item) in dictionary {
                if let dict = item as? [String: Any] {
                    let bird = Bird(identifier: key, dictionary: dict)
                    if bird.departureDate > Date() {
                        birds.append(bird)
                    }
                }
            }
            birds.sort(by: { (bird1, bird2) -> Bool in
                return bird1.departureDate < bird2.departureDate
            })
            success(birds)
        })
    }
    
}
