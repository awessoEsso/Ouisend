//
//  JsonDecoderHelper.swift
//  YukaTest
//
//  Created by Esso Awesso on 13/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation

class JsonDecoderHelper {

    init() {}
    
    func decodeCitiesJSONData(jsonData: Data) -> [City]? {
        do {
            let cities = try JSONDecoder().decode([City].self, from: jsonData)
            return cities
        } catch let jsonErr {
            print("Error serializing json:", jsonErr)
        }
        return nil
    }

}
