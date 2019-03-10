//
//  Bird.swift
//  Ouisend
//
//  Created by Esso Awesso on 22/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation
import SwiftDate

class Bird {
    
    var identifier: String
    var departureCity: String
    var departureCountry: String
    var departureDate: Date
    var arrivalCity: String
    var arrivalCountry: String
    var arrivalDate: Date
    var birdWeight: Int
    var birdPricePerKilo: Int
    var birdTotalPrice: Int
    var birdTravelerName: String
    var birderProfilePicUrl: URL
    var currency: String
    var creator: String
    var createdAt: Date
    
    
    init(birdTravelerName: String, birdTravelerProfilePic: String, departureCity: String, departureCountry: String, departureDate: Date, arrivalCity: String, arrivalCountry: String, arrivalDate: Date, birdWeight: Int, birdTotalPrice: Int, birdPricePerKilo: Int, currency: String = "€", creator: String, createdAt: Date = Date()) {
        self.identifier = ""
        self.birdTravelerName = birdTravelerName
        self.birderProfilePicUrl = URL(string: birdTravelerProfilePic)!
        self.departureCity = departureCity
        self.departureCountry = departureCountry
        self.departureDate = departureDate
        self.arrivalCity = arrivalCity
        self.arrivalCountry = arrivalCountry
        self.arrivalDate = arrivalDate
        self.birdWeight = birdWeight
        self.birdTotalPrice = birdTotalPrice
        self.birdPricePerKilo = birdPricePerKilo
        self.currency = currency
        self.creator = creator
        self.createdAt = createdAt
    }
    
    init(dictionnary: [String: Any?]) {
        self.identifier = ""
        self.birdTravelerName = dictionnary["birderName"] as? String ?? ""
        let profilePicUrlString = dictionnary["birderProfilePicUrl"] as? String ?? ""
        self.birderProfilePicUrl = URL(string: profilePicUrlString) ?? URL(string: "http://google.com")!
        self.departureCity = dictionnary["cb_ville_depart"] as? String ?? ""
        self.departureCountry = dictionnary["cb_pays_depart"] as? String ?? ""
        self.departureDate = dictionnary["cb_date_depart"] as? Date ?? Date()
        self.arrivalCity = dictionnary["cb_ville_arrivee"] as? String ?? ""
        self.arrivalCountry = dictionnary["cb_pays_arrivee"] as? String ?? ""
         self.arrivalDate = dictionnary["cb_date_arrivee"] as? Date ?? Date()
        self.birdWeight = dictionnary["cb_bird_weight"] as? Int ?? 0
        self.birdTotalPrice = dictionnary["cb_bird_total_price"] as? Int ?? 0
        self.birdPricePerKilo = dictionnary["cb_bird_price_per_k"] as? Int ?? 0
        self.currency = dictionnary["cb_currency"] as? String ?? ""
        self.creator = dictionnary["creator"] as? String ?? ""
        self.createdAt = Date()
    }
    
    init(identifier anIdentifier: String, dictionary: [String: Any]) {
        self.identifier = anIdentifier
        
        self.birdTravelerName = dictionary["birderName"] as? String ?? ""

        self.birderProfilePicUrl = URL(string: (dictionary["birderProfilePicUrl"] as? String ?? "http://google.com"))!
        
        self.departureCity = dictionary["departureCity"] as? String ?? ""
        self.departureCountry = dictionary["departureCountry"] as? String ?? ""
        
        let departureDateTimestamp = dictionary["departureDate"] as? TimeInterval ?? 0
        let arrivalDateTimestamp = dictionary["arrivalDate"] as? TimeInterval ?? 0
        
        self.departureDate = Date(timeIntervalSince1970: departureDateTimestamp / 1000)

        self.arrivalCity = dictionary["arrivalCity"] as? String ?? ""
        self.arrivalCountry = dictionary["arrivalCountry"] as? String ?? ""
        self.arrivalDate = Date(timeIntervalSince1970: arrivalDateTimestamp / 1000)
        self.birdWeight = dictionary["birdWeight"] as? Int ?? 0
        self.birdTotalPrice = dictionary["birdTotalPrice"] as? Int ?? 0
        self.birdPricePerKilo = dictionary["birdPricePerKilo"] as? Int ?? 0
        self.currency = dictionary["currency"] as? String ?? ""
        self.creator = dictionary["creator"] as? String ?? ""
        self.createdAt = Date(timeIntervalSince1970: ((dictionary["createdAt"] as? TimeInterval ?? 0) / 1000))
        
    }
    
}
