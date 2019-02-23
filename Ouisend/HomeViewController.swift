//
//  HomeViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 22/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    var birds: [Bird] = [
        Bird(birdTravelerName: "Kyle Loftus", birdTravelerProfilePic: "kyle", departureCity: "Paris", departureCountry: "France", arrivalCity: "Lome", arrivalCountry: "Togo", birdWeight: 23, birdPrice: 120, birdPriceIsPerKilo: false ),
        Bird(birdTravelerName: "Jonathan Borba", birdTravelerProfilePic: "jonathan", departureCity: "Montreal", departureCountry: "Canada", arrivalCity: "Bamako", arrivalCountry: "Burkina-Faso", birdWeight: 12, birdPrice: 60, birdPriceIsPerKilo: false ),
        Bird(birdTravelerName: "Claudia Van Zyl", birdTravelerProfilePic: "claudia", departureCity: "Dakar", departureCountry: "Sénégal", arrivalCity: "Lyon", arrivalCountry: "France", birdWeight: 20, birdPrice: 100, birdPriceIsPerKilo: false ),
        Bird(birdTravelerName: "James Barr", birdTravelerProfilePic: "james", departureCity: "New-York", departureCountry: "USA", arrivalCity: "Montreal", arrivalCountry: "Canada", birdWeight: 10, birdPrice: 80, birdPriceIsPerKilo: false ),
        Bird(birdTravelerName: "Chase Fade", birdTravelerProfilePic: "chase", departureCity: "Bruxelles", departureCountry: "Belgique", arrivalCity: "Kinshasa", arrivalCountry: "Congo", birdWeight: 8, birdPrice: 75, birdPriceIsPerKilo: false ),
        Bird(birdTravelerName: "Jose Ros", birdTravelerProfilePic: "jose", departureCity: "Paris", departureCountry: "France", arrivalCity: "San Franciso", arrivalCountry: "USA", birdWeight: 5, birdPrice: 70, birdPriceIsPerKilo: false ),
        Bird(birdTravelerName: "Jayson Hinrichsen", birdTravelerProfilePic: "jayson", departureCity: "Lomé", departureCountry: "Togo", arrivalCity: "Paris", arrivalCountry: "France", birdWeight: 23, birdPrice: 120, birdPriceIsPerKilo: false ),
    
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}


extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return birds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let bird = birds[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "birdcollectionviewcellid", for: indexPath) as! BirdCollectionViewCell
        
        cell.birderNameLabel.text = bird.birdTravelerName
        cell.birderPicImageView.image = UIImage(named: bird.birdTravelerProfilePic)
        cell.birdDepartureCityLabel.text = bird.departureCity
        cell.birdDepartureCountryLabel.text = bird.departureCountry
        cell.birdArrivalCityLabel.text = bird.arrivalCity
        cell.birdArrivalCountryLabel.text = bird.arrivalCountry
        cell.birdWeightLabel.text = "\(bird.birdWeight) Kg"
        cell.birdPriceLabel.text = "\(bird.birdPrice)€"
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth:CGFloat = collectionView.frame.width
        let cellHeight:CGFloat = 160
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
