//
//  SearchBirdViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 06/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class SearchBirdViewController: UIViewController {
    
    var departureSelected = true
    
    var birds: [Bird]!
    
    var filteredBirds: [Bird]!
    
    var departureCity = ""
    
    var arrivalCity = ""
    
    @IBOutlet weak var departureView: UIView!
    
    @IBOutlet weak var arrivalView: UIView!
    
    @IBOutlet weak var searchDepartureView: UIView!
    
    @IBOutlet weak var searchArriValView: UIView!
    
    @IBOutlet weak var departureCountryNameLabel: UILabel!
    
    @IBOutlet weak var departureCityNameLabel: UIButton!
    
    @IBOutlet weak var arrivalCountryNameLabel: UILabel!
    
    @IBOutlet weak var arrivalCityNameLabel: UIButton!
    
    @IBOutlet weak var birdsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectDepartureAction(_ sender: UIButton) {
        departureSelected = true
        performSegue(withIdentifier: "searchCitySegueId", sender: nil)
    }
    
    @IBAction func selectArrivalAction(_ sender: UIButton) {
        departureSelected = false
        performSegue(withIdentifier: "searchCitySegueId", sender: nil)
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
            
        default:
            print("Unknown Segue")
        }
    }
    
    
    func updateBirds() {
        filterDeparture()
        filterArrival()
        birdsCollectionView.reloadData()
    }
    
    func filterDeparture() {
        if departureCity.isEmpty == true {
            filteredBirds = birds
        }
        else {
            filteredBirds = birds.filter{ $0.departureCity.lowercased().contains(departureCity.lowercased())}
        }
    }
    
    func filterArrival() {
        let tampBirds: [Bird] = filteredBirds
        if arrivalCity.isEmpty == true {
            filteredBirds = tampBirds
        }
        else {
            filteredBirds = tampBirds.filter{ $0.arrivalCity.lowercased().contains(arrivalCity.lowercased())}
        }
    }
    
    
}

extension SearchBirdViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredBirds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bird = filteredBirds[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "birdcollectionviewcellid", for: indexPath) as! BirdCollectionViewCell
        
        cell.birderNameLabel.text = bird.birdTravelerName
        
        cell.birdPublishedTimeLabel.text = "Publié \(bird.createdAt.toStringWithRelativeTime(strings: relativeTimeDict))"
        
        cell.birderPicImageView.sd_setImage(with: bird.birderProfilePicUrl, completed: nil)
        cell.birdDepartureCityLabel.text = bird.departureCity
        cell.birdDepartureCountryLabel.text = bird.departureCountry
        cell.departureDateLabel.text = FrenchDateFormatter.formatDate(bird.departureDate)
        cell.birdArrivalCityLabel.text = bird.arrivalCity
        cell.birdArrivalCountryLabel.text = bird.arrivalCountry
        cell.birdWeightLabel.text = "\(bird.birdWeight) Kg"
        cell.birdPriceLabel.text = "\(bird.birdTotalPrice)\(bird.currency)"
        
        return cell
    }
    
    
}

extension SearchBirdViewController: SearchCityViewControllerDelegate {
    func didSelect(city: City, for departure: Bool) {
        if departure == true {
            departureCity = city.name ?? ""
            departureView.isHidden = false
            searchDepartureView.isHidden = true
            departureCityNameLabel.setTitle(city.name, for: .normal)
            departureCountryNameLabel.text = city.countryName
            
        }
        else {
            arrivalCity = city.name ?? ""
            arrivalView.isHidden = false
            searchArriValView.isHidden = true
            arrivalCityNameLabel.setTitle(city.name, for: .normal)
            arrivalCountryNameLabel.text = city.countryName
        }
        
        updateBirds()
    }
    
}
