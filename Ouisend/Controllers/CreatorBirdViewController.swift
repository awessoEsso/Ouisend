//
//  CreatorBirdViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 10/04/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class CreatorBirdViewController: UIViewController {
    
    @IBOutlet weak var birderProfilePic: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var birderNameLabel: UILabel!
    
    @IBOutlet weak var publishedDateLabel: UILabel!
    
    @IBOutlet weak var birdDateLabel: UILabel!
    
    @IBOutlet weak var totalWeightLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var pricePerKiloLabel: UILabel!
    
    @IBOutlet weak var seeBirdRequestsButton: UIButton!
    
    
    var bird: Bird!
    
    var birdRequests = [Request]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "\(bird.departureCity)  -  \(bird.arrivalCity)"
        
        tabBarController?.tabBar.isHidden = true
        
        setupBird(bird)
        
        FirebaseManager.shared.birdRequests(with: bird.identifier, success: { (birdRequests) in
            if birdRequests.count > 0 {
                self.seeBirdRequestsButton.isHidden = false
                self.birdRequests = birdRequests
            }
        }) { (error) in
            print(error?.localizedDescription ?? "Error loading bird Requests")
        }
    }
    
    
    func setupBird(_ bird: Bird) {
        birderNameLabel.text = bird.birdTravelerName
        publishedDateLabel.text = "Publié \(bird.createdAt.toStringWithRelativeTime(strings: relativeTimeDict))"
        let departureDate = FrenchDateFormatter.formatDate(bird.departureDate)
        birdDateLabel.text = "Départ: \(departureDate)"
        birderProfilePic.sd_setImage(with: bird.birderProfilePicUrl, completed: nil)
        totalWeightLabel.text =  "\(bird.birdWeight) Kg"
        totalPriceLabel.text = "\(bird.birdTotalPrice)\(bird.currency)"
        pricePerKiloLabel.text = "\(bird.birdPricePerKilo)\(bird.currency)"
    }
    
    
    
    
    @IBAction func viewRequestsAction(_ sender: UIButton) {
        
        performSegue(withIdentifier: "showBirdRequestId", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        switch destination {
            
        case is UpdateBirdViewController:
            let updateBirdViewController = destination as! UpdateBirdViewController
            updateBirdViewController.delegate = self
            updateBirdViewController.bird = bird
        
        case is MyBirdRequestsViewController:
            let myBirdRequestsViewController = destination as! MyBirdRequestsViewController
            myBirdRequestsViewController.bird = self.bird
            myBirdRequestsViewController.birdRequests = self.birdRequests
            
        default:
            print("Unknown Segue")
        }
    }

}


extension CreatorBirdViewController: UpdateBirdViewControllerDelegate {
    func didUpdateBird(_ bird: Bird) {
        setupBird(bird)
    }
}
