//
//  FirebaseManager+Bird.swift
//  Ouisend
//
//  Created by Esso Awesso on 24/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation
import Firebase

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
            "arrivalCity": bird.arrivalCity,
            "arrivalCountry": bird.arrivalCountry,
            "birdWeight": bird.birdWeight,
            "birdPrice": bird.birdPrice,
            "birdPriceIsPerKilo": bird.birdPriceIsPerKilo,
            "birdTravelerName": bird.birdTravelerName,
            "birdTravelerProfilePic": bird.birdTravelerProfilePic,
            "createdAt": ServerValue.timestamp()
            ] as [String : Any]
        
        birdReference.setValue(newBird) { (error, reference) in
            error == nil ? success?() :  failure?(error)
        }
    }
    
}
