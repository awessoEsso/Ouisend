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
            "departureDate": bird.departureDate.description ,
            "arrivalCity": bird.arrivalCity,
            "arrivalCountry": bird.arrivalCountry,
            "arrivalDate": bird.arrivalDate.description ,
            "birdWeight": bird.birdWeight,
            "birdTotalPrice": bird.birdTotalPrice,
            "birdPricePerKilo": bird.birdPricePerKilo,
            "birderName": bird.birdTravelerName,
            "birderProfilePicUrl": bird.birderProfilePicUrl.absoluteString,
            "currency": bird.currency,
            "createdAt": ServerValue.timestamp()
            ] as [String : Any]
        
        birdReference.setValue(newBird) { (error, reference) in
            error == nil ? success?() :  failure?(error)
        }
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
