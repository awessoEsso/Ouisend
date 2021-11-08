//
//  NotificationsViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 06/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    var cities = [City]()
    
    @IBOutlet weak var citiesTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cities = Datas.shared.cities
    }
    


}

extension NotificationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = cities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "citiesTableViewCellId", for: indexPath)
        cell.textLabel?.text = city.name
        return cell
    }
}

extension NotificationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let cityName = cell?.textLabel?.text ?? ""
        if let accessoryType = cell?.accessoryType {
            let subscribeBool = accessoryType == .none
            if subscribeBool {
                cell?.accessoryType = .checkmark
                // subscribe to topic
                print("subscribe to \(cityName)")
                FIRMessagingService.shared.subscribe(to: cityName)
            }
            else {
                cell?.accessoryType = .none
                print("unsubscribe to \(cityName)")
                FIRMessagingService.shared.unsubscribe(from: cityName)
            }
            
        }
        
    }
}
