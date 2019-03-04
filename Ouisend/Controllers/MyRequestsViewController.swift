//
//  MyRequestsViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 03/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class MyRequestsViewController: UIViewController {
    
    @IBOutlet weak var requestsCollectionView: UICollectionView!
    
    var myRequests = [Request]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        FirebaseManager.shared.myRequests({ (requests) in
            self.myRequests = requests
            self.requestsCollectionView.reloadData()
        }) { (error) in
            print(error?.localizedDescription ?? "Error loading Requests")
        }
        
    }

}

extension MyRequestsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myRequests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myRequest = myRequests[indexPath.item]
        let status = myRequest.status.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyRequestCollectionViewCellId", for: indexPath) as! MyRequestCollectionViewCell
        
        cell.travelDescriptionLabel.text = "\(myRequest.departureCity) - \(myRequest.arrivalCity) "
        cell.weightLabel.text = "\(myRequest.weight) Kg"
        cell.birderProfilePicImageView.sd_setImage(with: myRequest.birderProfilePicUrl, completed: nil)
        cell.birdStatusDescriptionLabel.text = requestStatusDescriptions[status]
        cell.backgroundColor = requestColors[status]
        cell.birdStatusImageView.image = requestIconViews[status]
        
        return cell
    }
}

extension MyRequestsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let myRequest = myRequests[indexPath.item]
        print(myRequest.status)
    }
}

extension MyRequestsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 120)
    }
}

