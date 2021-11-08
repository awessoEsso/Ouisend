//
//  DatasManager.swift
//  YukaTest
//
//  Created by Esso Awesso on 12/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation

class DatasManager {
    
    var localDatasManager = LocalDatasManager()
    var serverDatasManager = ServerDatasManager()
    
    init() {
        serverDatasManager.delegate = self
    }
    
    func getCities(success: @escaping (([City]) -> Void), failure: ((Error?) -> Void)?) {
        if let path = Bundle.main.path(forResource: "world-cities", ofType: "json") {
            let citiesJsonData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            if let cities = JsonDecoderHelper().decodeCitiesJSONData(jsonData: citiesJsonData) {
                var citiesDict = [String:Int]()
                var filteredCities = [City]()
                for city in cities {
                    let cityName = city.name!
                    if citiesDict[cityName] == nil {
                        citiesDict[cityName] = city.geonameid!
                        filteredCities.append(city)
                    }
                    else {
                        print("City \(cityName) already exist, delete \(city.geonameid!)")
                    }
                }
                success(filteredCities)
            }
        }
    }
    
    func saveCategoriesData(_ data: Data) -> Bool {
        return localDatasManager.saveCitiesData(data)
    }
}


extension DatasManager: ServerDatasManagerDelegate {
    func saveCitiesData(_ data: Data) {
        let _ = localDatasManager.saveCitiesData(data)
    }
}
