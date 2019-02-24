//
//  City.swift
//  Ouisend
//
//  Created by Esso Awesso on 24/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation


class City {
    
    // MARK: properties
    internal(set) var identifier: String
    internal(set) var name: String?
    internal(set) var countryCode: String?
    internal(set) var countryName: String?
    
    init(identifier anIdentifier: String) {
        identifier = anIdentifier
    }
    
    convenience init(identifier anIdentifier: String, dictionary: [String: Any]) {
        self.init(identifier: anIdentifier)
        name = dictionary["name"] as? String
        countryCode = dictionary["countryCode"] as? String
        countryName = dictionary["countryName"] as? String
    }
}
