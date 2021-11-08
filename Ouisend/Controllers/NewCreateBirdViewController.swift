//
//  NewCreateBirdViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 31/05/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import SCLAlertView

class NewCreateBirdViewController: UIViewController {
    
    @IBOutlet weak var departureButton: UIButton!
    
    @IBOutlet weak var destinationButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var departureCity:City?
    
    var destinationCity:City?
    
    var departureSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
        if departureCity == nil && destinationCity == nil {
            //self.title = "Toutes les publications"
            return .any
        }
        else if destinationCity == nil && departureCity != nil {
            //Filter on Departure
            return .onlyDeparture
        }
        else if departureCity == nil && destinationCity != nil {
            //Filter on Destination
            return .onlyDestination
        }
        else {
            return .all
        }
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        if departureCity != nil {
            if destinationCity != nil  {
                performSegue(withIdentifier: "showSelectDepartureDate", sender: nil)
            }
            else {
                SCLAlertView().showError("Erreur", subTitle: "Veuillez renseigner la ville de départ svp.")
            }
        }
        else {
            SCLAlertView().showError("Erreur", subTitle: "Veuillez renseigner la ville de départ svp.")
        }
        
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
            
        case is ChooseDepartureDateViewController:
            let chooseDepartureDateViewController = destination as! ChooseDepartureDateViewController
            chooseDepartureDateViewController.departureCity = departureCity
            chooseDepartureDateViewController.destinationCity = destinationCity
            
            
        case is SearchResultsViewController:
            let searchResultsViewController = destination as! SearchResultsViewController
            searchResultsViewController.departureCity = departureCity
            searchResultsViewController.destinationCity = destinationCity
            searchResultsViewController.searchCase = getSearchCase()
            
            
        default:
            print("Unknown Segue")
        }
        
    }
    
    func resetForm() {
        departureButton.setTitle("Départ", for: .normal)
        destinationButton.setTitle("Destination", for: .normal)
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
        departureCity = nil
        destinationCity = nil
        tabBarController?.selectedIndex = 1
    }
    
}


extension NewCreateBirdViewController: SearchCityViewControllerDelegate {
    func didSelect(city: City, for departure: Bool) {
        //searchButton.setTitle("Rechercher", for: .normal)
        let title = "\(city.name ?? "") - \(city.country ?? "")"
        if departure == true {
            departureCity = city
            departureButton.setTitle(title, for: .normal)
        }
        else {
            destinationCity = city
            destinationButton.setTitle(title, for: .normal)
        }
        
        if departureCity != nil && destinationCity != nil {
            nextButton.isEnabled = true
            nextButton.alpha = 1
        }
    }
    
}
