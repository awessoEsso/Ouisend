//
//  ServerDatasManager.swift
//  YukaTest
//
//  Created by Esso Awesso on 13/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation

enum ServerConfiguration:String {
    case CITIES_API_URL = "https://datahub.io/core/world-cities/r/0.json"
}


protocol ServerDatasManagerDelegate {
    func saveCitiesData(_ data: Data)
}


class ServerDatasManager {
    
    var delegate: ServerDatasManagerDelegate?
    
    init() {}
    
    func loadCities(success: @escaping (([City]) -> Void), failure: ((Error?) -> Void)?) {
        
        let citiesUrlString = ServerConfiguration.CITIES_API_URL.rawValue
        
        guard let citiesUrl = URL(string: citiesUrlString) else {
            let error = NSError(domain: "BadUrl", code: 001, userInfo: ["url" : citiesUrlString])
            failure?(error)
            return
        }
        
        loadDataFromUrl(url: citiesUrl, success: { (citiesJsonData) in
            if let cities = JsonDecoderHelper().decodeCitiesJSONData(jsonData: citiesJsonData) {
                success(cities)
                //Strategy to have offline Mode by saving data in Documents as a Json File
                self.delegate?.saveCitiesData(citiesJsonData)
            }
            else {
                let error = NSError(domain: "Format Error", code: 002, userInfo: nil)
                failure?(error)
            }
        }) { (error) in
            let error = NSError(domain: "Format Error", code: 002, userInfo: nil)
            failure?(error)
        }
    }
    
    
    private func loadDataFromUrl(url: URL, success: @escaping ((Data) -> Void), failure: ((Error?) -> Void)?) {
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let error = err {
                failure?(error)
            }
            else {
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status Code: \(httpResponse.statusCode)")
                    let statusCode = httpResponse.statusCode
                    switch statusCode {
                    case 200:
                        print("success")
                        success(data!)
                    default:
                        print("default")
                        let error = NSError(domain: "Server Error", code: 004, userInfo: ["url" : url])
                        failure?(error)
                    }
                }
            }
            }.resume()
    }
}
