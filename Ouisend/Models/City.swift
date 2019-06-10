//
//  City.swift
//  Ouisend
//
//  Created by Esso Awesso on 24/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation

class City: Decodable {
    
    let name: String?
    let country: String?
    let geonameid: Int?
    let subcountry: String?
    
    init(name: String, country: String, geonameid: Int, subcountry: String) {
        self.name = name
        self.country = country
        self.geonameid = geonameid
        self.subcountry = subcountry
    }
    
    deinit {
        print("City with name \(name ?? "") is being deinitialised")
    }
    
}

extension City: SearchItem {
    func matchesSearchQuery(_ query: String) -> Bool {
        let textToSearch = query.removeAccents().lowercased()
        let cityName = name?.removeAccents().lowercased() ?? ""
        return cityName.contains(textToSearch)
    }
}
extension City: Equatable {
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.geonameid == rhs.geonameid
    }
}
extension City: CustomStringConvertible {
    var description: String {
        return name ?? ""
    }
}
