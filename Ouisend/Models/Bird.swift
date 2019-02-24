//
//  Bird.swift
//  Ouisend
//
//  Created by Esso Awesso on 22/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation


class Bird {
    
    var departureCity: String
    var departureCountry: String
    var arrivalCity: String
    var arrivalCountry: String
    var birdWeight: Int
    var birdPrice: Int
    var birdPriceIsPerKilo: Bool
    var birdTravelerName: String
    var birdTravelerProfilePic: String
    var birderProfilePicUrl: URL
    var createdAt: Date
    
    
    init(birdTravelerName: String, birdTravelerProfilePic: String, departureCity: String, departureCountry: String, arrivalCity: String, arrivalCountry: String, birdWeight: Int, birdPrice: Int, birdPriceIsPerKilo: Bool, createdAt: Date = Date()) {
        self.birdTravelerName = birdTravelerName
        self.birdTravelerProfilePic = birdTravelerProfilePic
        self.birderProfilePicUrl = URL(string: birdTravelerProfilePic)!
        self.departureCity = departureCity
        self.departureCountry = departureCountry
        self.arrivalCity = arrivalCity
        self.arrivalCountry = arrivalCountry
        self.birdWeight = birdWeight
        self.birdPrice = birdPrice
        self.birdPriceIsPerKilo = birdPriceIsPerKilo
        self.createdAt = createdAt
    }
    
    
    init(dictionnary: [String: Any?]) {
        self.birdTravelerName = dictionnary["birderName"] as? String ?? ""
        self.birderProfilePicUrl = dictionnary["birderProfilePicUrl"] as? URL ?? URL(string: "http://google.com")!
        self.birdTravelerProfilePic = dictionnary["birderProfilePicUrl"] as? String ?? ""
        
        self.departureCity = dictionnary["cb_ville_depart"] as? String ?? ""
        self.departureCountry = dictionnary["cb_pays_depart"] as? String ?? ""
        self.arrivalCity = dictionnary["cb_ville_arrivee"] as? String ?? ""
        self.arrivalCountry = dictionnary["cb_pays_arrivee"] as? String ?? ""
        self.birdWeight = dictionnary["cb_bird_weight"] as? Int ?? 0
        self.birdPrice = dictionnary["cb_bird_price"] as? Int ?? 0
        self.birdPriceIsPerKilo = dictionnary["cb_bird_perkilo"] as? Bool ?? false
        self.createdAt = Date()
        
        
        
    }
    
}
