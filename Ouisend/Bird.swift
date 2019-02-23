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
    var createdAt: Date
    
    
    init(birdTravelerName: String, birdTravelerProfilePic: String, departureCity: String, departureCountry: String, arrivalCity: String, arrivalCountry: String, birdWeight: Int, birdPrice: Int, birdPriceIsPerKilo: Bool, createdAt: Date = Date()) {
        self.birdTravelerName = birdTravelerName
        self.birdTravelerProfilePic = birdTravelerProfilePic
        self.departureCity = departureCity
        self.departureCountry = departureCountry
        self.arrivalCity = arrivalCity
        self.arrivalCountry = arrivalCountry
        self.birdWeight = birdWeight
        self.birdPrice = birdPrice
        self.birdPriceIsPerKilo = birdPriceIsPerKilo
        self.createdAt = createdAt
    }
    
}
