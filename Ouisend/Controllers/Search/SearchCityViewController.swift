//
//  SearchCityViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 17/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

protocol SearchCityViewControllerDelegate {
    func didSelect(city: City, for: Bool)
}

class SearchCityViewController: UIViewController {
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var seachForDeparture = true
    
    var cities: [City] = Datas.shared.cities
    
    var filteredCities: [City] = Datas.shared.cities
    
    var delegate: SearchCityViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = seachForDeparture ? "Ville de départ" : "Ville d'arrivée"
        
        searchBar.placeholder = seachForDeparture ? "Départ" : "Arrivée"
        
    }
    
    @IBAction func dismissAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
        let city = cities[indexPath.row]
        delegate?.didSelect(city: city, for: seachForDeparture)
        dismiss(animated: true, completion: nil)
    }
}


extension SearchCityViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty == true {
            filteredCities = cities
        }
        else {
            filteredCities = cities.filter({ (city) -> Bool in
                let cityName = city.name?.lowercased() ?? ""
                return cityName.contains(searchText.lowercased())
            })
        }
        citiesTableView.reloadData()
    }
}
