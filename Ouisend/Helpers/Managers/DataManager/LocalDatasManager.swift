//
//  LocalDatasManager.swift
//  YukaTest
//
//  Created by Esso Awesso on 13/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation

enum LocalFilesName:String {
    case CITIES = "cities.json"
}

class LocalDatasManager {
    
    init() {}
    
    func saveCitiesData(_ data: Data) -> Bool {
        return saveDataToLocalFile(data, fileName: LocalFilesName.CITIES.rawValue)
    }
    
    func loadCities() ->  [City]? {
        if let citiesData =  loadDataFromLocalFile(fileName: LocalFilesName.CITIES.rawValue) {
            if let cities = JsonDecoderHelper().decodeCitiesJSONData(jsonData: citiesData) {
                return cities
            }
        }
        return nil
    }
    
    private func saveDataToLocalFile(_ data: Data, fileName: String) -> Bool {
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            do {
                try data.write(to: fileURL)
                return true
            }
            
        } catch {
            print(error)
        }
        return false
    }
    
    private func loadDataFromLocalFile(fileName: String) -> Data? {
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            
            do {
                let data = try Data(contentsOf: fileURL)
                return data
            }
        }
        catch {
            print(error)
        }
        return nil
    }
}
