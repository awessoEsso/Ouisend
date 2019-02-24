//
//  Country.swift
//  Ouisend
//
//  Created by Esso Awesso on 24/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation

class Country {
    
    // MARK: properties
    internal(set) var identifier: String
    internal(set) var name: String?
    internal(set) var code: String?
    
    init(identifier anIdentifier: String) {
        identifier = anIdentifier
    }
    
    convenience init(identifier anIdentifier: String, dictionary: [String: Any]) {
        self.init(identifier: anIdentifier)
        name = dictionary["name"] as? String
        code = dictionary["code"] as? String
    }
}
