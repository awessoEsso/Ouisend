//
//  Request.swift
//  Ouisend
//
//  Created by Esso Awesso on 03/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation
import SwiftDate

class Request {
    
    var identifier: String
    var bird: String
    var weight: Int
    var details: String
    var birderName: String
    var birderProfilePicUrl: URL
    var questerName: String
    var questerProfilePicUrl: URL
    var departureCity: String
    var departureCountry: String
    var departureDate: Date
    var arrivalCity: String
    var arrivalCountry: String
    var arrivalDate: Date
    var status: RequestStatus
    var creator: String
    var createdAt: Date
    
    
    init(bird: String, weight: Int, details: String, birderName: String, birderProfilePicUrl: URL, questerName: String, questerProfilePicUrl: URL, departureCity: String, departureCountry: String, departureDate: Date, arrivalCity: String, arrivalCountry: String, arrivalDate: Date, creator: String, createdAt: Date = Date()) {
        self.identifier = ""
        self.bird = bird
        self.weight = weight
        self.details = details
        self.birderName = birderName
        self.birderProfilePicUrl = birderProfilePicUrl
        self.questerName = questerName
        self.questerProfilePicUrl = questerProfilePicUrl
        self.departureCity = departureCity
        self.departureCountry = departureCountry
        self.departureDate = departureDate
        self.arrivalCity = arrivalCity
        self.arrivalCountry = arrivalCountry
        self.arrivalDate = arrivalDate
        self.status = .pending
        self.creator = creator
        self.createdAt = createdAt
    }
    
    
    init(identifier anIdentifier: String, dictionary: [String: Any]) {
        self.identifier = anIdentifier
        self.bird = dictionary["bird"] as? String ?? ""
        self.weight = dictionary["weight"] as? Int ?? 0
        self.details = dictionary["details"] as? String ?? ""
        self.birderName = dictionary["birderName"] as? String ?? ""
        let birderProfilePicUrlString = dictionary["birderProfilePicUrl"] as? String ?? ""
        self.birderProfilePicUrl = URL(string: birderProfilePicUrlString)!
        self.questerName = dictionary["questerName"] as? String ?? ""
        let questerProfilePicUrlString = dictionary["questerProfilePicUrl"] as? String ?? ""
        self.questerProfilePicUrl = URL(string: questerProfilePicUrlString) ?? URL(string: "https://graph.facebook.com/1979723412333172/picture")!
        self.departureCity = dictionary["departureCity"] as? String ?? ""
        self.departureCountry = dictionary["departureCountry"] as? String ?? ""
        
        let departureDateTimestamp = dictionary["departureDate"] as? TimeInterval ?? 0
        let arrivalDateTimestamp = dictionary["arrivalDate"] as? TimeInterval ?? 0
        
        self.departureDate = Date(timeIntervalSince1970: departureDateTimestamp / 1000)
        
        
        self.arrivalCity = dictionary["arrivalCity"] as? String ?? ""
        self.arrivalCountry = dictionary["arrivalCountry"] as? String ?? ""
        self.arrivalDate = Date(timeIntervalSince1970: arrivalDateTimestamp / 1000)
        
        let statusValue = dictionary["status"] as? Int ?? 1
        
        switch statusValue {
        case 2:
            self.status = .rejected
        case 3:
            self.status = .accepted
        default:
            self.status = .pending
        }
        
        self.creator = dictionary["creator"] as? String ?? ""
        self.createdAt = Date(timeIntervalSince1970: ((dictionary["createdAt"] as? TimeInterval ?? 0) / 1000))
    }
    
}


enum RequestStatus: Int {
    case pending = 1
    case rejected = 2
    case accepted = 3
}

let requestColors: [Int: UIColor] = [
    1: UIColor(red: 97/255, green: 183/255, blue: 222/255, alpha: 1),
    2: UIColor(red: 216/255, green: 17/255, blue: 89/255, alpha: 1),
    3: UIColor(red: 85/255, green: 184/255, blue: 145/255, alpha: 1),
]

let requestIconViews: [Int: UIImage] =  [
    1: #imageLiteral(resourceName: "ios-help-outline"),
    2: #imageLiteral(resourceName: "ios-close-outline"),
    3: #imageLiteral(resourceName: "ios-navigate-outline"),
]

let requestStatusDescriptions: [Int: String] =  [
    1: "En attente",
    2: "Refusé",
    3: "Accepté",
]
