//
//  SimpleSearchViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 22/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class SimpleSearchViewController: UIViewController {
    
    
    @IBOutlet weak var badgeButtonItem: BadgeBarButtonItem!
    
    @IBOutlet weak var departureButton: UIButton!
    
    @IBOutlet weak var destinationButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    
    var departureCity = ""
    
    var destinationCity = ""
    
    var departureSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        FirebaseManager.shared.myChannelsUnreadCount({ (unreadCount) in
            self.badgeButtonItem.badgeNumber = unreadCount
        }) { (error) in
            print(error?.localizedDescription ?? "")
        }
        
        
    }
    
    @IBAction func departureAction(_ sender: UIButton) {
        departureSelected = true
        performSegue(withIdentifier: "selectCitySegueId", sender: nil)
    }
    
    
    @IBAction func destinationAction(_ sender: UIButton) {
        departureSelected = false
        performSegue(withIdentifier: "selectCitySegueId", sender: nil)
    }
    
    func getSearchCase() -> SearchCase {
        if departureCity.isEmpty && destinationCity.isEmpty {
            //self.title = "Toutes les publications"
            return .any
        }
        else if destinationCity.isEmpty == true && departureCity.isEmpty == false {
            //Filter on Departure
            return .onlyDeparture
        }
        else if departureCity.isEmpty && destinationCity.isEmpty == false {
            //Filter on Destination
            return .onlyDestination
        }
        else {
            return .all
        }
    }
    
    @IBAction func cancelFilters(_ sender: UIButton) {
        
        departureButton.setTitle("Départ", for: .normal)
        destinationButton.setTitle("Destination", for: .normal)
        searchButton.setTitle("Voir tous les birds", for: .normal)
        departureCity = ""
        destinationCity = ""
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        switch destination {
            
        case is UINavigationController:
            let navigationController = destination as! UINavigationController
            if let searchCityViewController = navigationController.viewControllers.first as? SearchCityViewController {
                searchCityViewController.delegate = self
                searchCityViewController.seachForDeparture = departureSelected
            }
            
        case is SearchResultsViewController:
            let searchResultsViewController = destination as! SearchResultsViewController
            searchResultsViewController.departureCity = departureCity
            searchResultsViewController.destinationCity = destinationCity
            searchResultsViewController.searchCase = getSearchCase()
            
            
        default:
            print("Unknown Segue")
        }
    }
    
}


extension SimpleSearchViewController: SearchCityViewControllerDelegate {
    func didSelect(city: City, for departure: Bool) {
        searchButton.setTitle("Rechercher", for: .normal)
        let title = "\(city.name ?? "") - \(city.countryName ?? "")"
        if departure == true {
            departureCity = city.name ?? ""
            departureButton.setTitle(title, for: .normal)
        }
        else {
            destinationCity = city.name ?? ""
            destinationButton.setTitle(title, for: .normal)
        }
    }
    
}

enum SearchCase {
    case onlyDeparture
    case onlyDestination
    case any
    case all
}
