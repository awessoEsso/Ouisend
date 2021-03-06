//
//  SearchCityViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 17/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Disk
import SwiftyJSON

protocol SearchCityViewControllerDelegate {
    func didSelect(city: City, for: Bool)
}

class SearchCityViewController: UIViewController {
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var activityIndicatorView:NVActivityIndicatorView!
    
    var seachForDeparture = true
    
    var cities: [City] = [City]()
    
    var filteredCities: [City] = [City]()
    
    var delegate: SearchCityViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = seachForDeparture ? "Ville de départ" : "Ville d'arrivée"
        searchBar.placeholder = seachForDeparture ? "Départ" : "Arrivée"
        
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: view.frame.width/2 - 40, y: view.frame.height/2 - 40), size: CGSize(width: 80, height: 80)), type: .orbit, color: UIColor.Blue.ouiSendBlueColor, padding: 20)
        
        cities = Datas.shared.cities
        
        filteredCities = Datas.shared.cities
        
        view.addSubview(activityIndicatorView)
        
        searchBar.becomeFirstResponder()
        
    }
    
    @IBAction func dismissAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

}

extension SearchCityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let city = filteredCities[indexPath.row]
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cityTableViewCellId", for: indexPath)
        
        cell.textLabel?.text = city.name
        
        return cell
    }
    
    
}


extension SearchCityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = filteredCities[indexPath.row]
        delegate?.didSelect(city: city, for: seachForDeparture)
        dismiss(animated: true, completion: nil)
    }
}


extension SearchCityViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let textToSearch = searchText.removeAccents().lowercased()
        
        if searchText.isEmpty == true {
            filteredCities = cities
        }
        else {
            filteredCities = cities.filter({ (city) -> Bool in
                let cityName = city.name?.removeAccents().lowercased() ?? ""
                return cityName.contains(textToSearch)
            })
        }
        citiesTableView.reloadData()
    }
}
