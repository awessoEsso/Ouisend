//
//  FirebaseManager+City.swift
//  Ouisend
//
//  Created by Esso Awesso on 24/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension FirebaseManager {
    
    func cities(with success: @escaping (([City]) -> Void), failure: ((Error?) -> Void)?) {
        citiesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else {
                let anError = NSError(domain: "error occured: can't retreive cities", code: 30001, userInfo: nil)
                failure?(anError)
                return
            }
            var cities = [City]()
            for (key, item) in dictionary {
                if let dict = item as? [String: Any] {
                    let city = City(identifier: key, dictionary: dict)
                    cities.append(city)
                }
            }
            success(cities)
        })
    }
    
}
