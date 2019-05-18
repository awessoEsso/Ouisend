//
//  Birder.swift
//  Ouisend
//
//  Created by Esso Awesso on 23/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation
import FirebaseAuth

class Birder: NSObject, NSCoding {
    
    // MARK: properties
    var identifier: String
    var displayName: String?
    var email: String?
    var photoURL: URL?
    var phoneNumber: String?
    var isEnabled: Bool?
    
    init(identifier anIdentifier: String) {
        identifier = anIdentifier
    }
    
    convenience init(user: User) {
        self.init(identifier: user.uid)
        displayName = user.displayName
        email = user.email
        photoURL = user.photoURL
        phoneNumber = user.phoneNumber
        isEnabled = true
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
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(identifier, forKey: "identifier")
        aCoder.encode(displayName, forKey: "displayName")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(photoURL, forKey: "photoURL")
        aCoder.encode(isEnabled, forKey: "isEnabled")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.identifier = aDecoder.decodeObject(forKey: "identifier") as? String ?? ""
        self.displayName = aDecoder.decodeObject(forKey: "displayName") as? String ?? ""
        self.email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        self.phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as? String ?? ""
        self.photoURL = aDecoder.decodeObject(forKey: "photoURL") as? URL ?? URL(string: "http://www.ouisend.fr")
        self.isEnabled = aDecoder.decodeObject(forKey: "isEnabled") as? Bool ?? true
    }
}
