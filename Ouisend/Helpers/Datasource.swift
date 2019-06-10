//
//  Datasource.swift
//  CNSS
//
//  Created by Esso Awesso on 28/07/2018.
//  Copyright © 2018 Esso Awesso. All rights reserved.
//

import Foundation
import ObjectMapper

class DataSource<T:Mappable>  {


    // MARK: - object wrapper
    
    static func fromJson(_ jsonData: AnyObject) -> T? {
        return Mapper<T>().map(JSONObject: jsonData)
    }
    
    static func arrayFromJson(_ jsonData: AnyObject) -> [T]? {
        return Mapper<T>().mapArray(JSONObject: jsonData)
    }
}
