//
//  CreatedBirdViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 10/04/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class CreatedBirdViewController: UIViewController {
    
    @IBOutlet weak var birderProfilePic: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var birderNameLabel: UILabel!
    
    @IBOutlet weak var publishedDateLabel: UILabel!
    
    @IBOutlet weak var birdDateLabel: UILabel!
    
    @IBOutlet weak var totalWeightLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var pricePerKiloLabel: UILabel!
    
    var bird: Bird!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "\(bird.departureCity)  -  \(bird.arrivalCity)"
        
        tabBarController?.tabBar.isHidden = true
        
        birderNameLabel.text = bird.birdTravelerName
        publishedDateLabel.text = "Publié \(bird.createdAt.toStringWithRelativeTime(strings: relativeTimeDict))"
        let departureDate = FrenchDateFormatter.formatDate(bird.departureDate)
        birdDateLabel.text = "Départ: \(departureDate)"
        birderProfilePic.sd_setImage(with: bird.birderProfilePicUrl, completed: nil)
        totalWeightLabel.text =  "\(bird.birdWeight) Kg"
        totalPriceLabel.text = "\(bird.birdTotalPrice)\(bird.currency)"
        pricePerKiloLabel.text = "\(bird.birdPricePerKilo)\(bird.currency)"
    }
    

    
     ///MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
 

}
