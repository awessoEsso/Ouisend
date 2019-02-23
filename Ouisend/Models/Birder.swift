//
//  Birder.swift
//  Ouisend
//
//  Created by Esso Awesso on 23/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation

class Birder {
    
    // MARK: properties
    internal(set) var identifier: String
    internal(set) var displayName: String?
    internal(set) var email: String?
    internal(set) var photoURL: URL?
    internal(set) var phoneNumber: String?
    internal(set) var isEnabled: Bool?
    
    init(identifier anIdentifier: String) {
        identifier = anIdentifier
    }
    
    convenience init(identifier anIdentifier: String, dictionary: [String: Any]) {
        self.init(identifier: anIdentifier)
        
        displayName = dictionary["name"] as? String
        email = dictionary["email"] as? String
        phoneNumber = dictionary["phoneNumber"] as? String
        isEnabled = dictionary["isEnabled"] as? Bool
        
        let profilePicture = dictionary["profilePicture"] as? [String: String]
        
        guard let photoURLAbsoluteString = profilePicture?["url"] else {
            photoURL = nil
            return
        }
        photoURL = URL(string: photoURLAbsoluteString)
    }
}
