//
//  MyBirdRequestsViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 04/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class MyBirdRequestsViewController: UIViewController {
    
    
    @IBOutlet weak var myBirdRequestsCollectionView: UICollectionView!
    
    var bird: Bird!
    
    var birdRequests = [Request]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "\(bird.departureCity)  -  \(bird.arrivalCity)"
        
        FirebaseManager.shared.birdRequests(with: bird.identifier, success: { (birdRequests) in
            self.birdRequests = birdRequests
            self.myBirdRequestsCollectionView.reloadData()
        }) { (error) in
            print(error?.localizedDescription ?? "Error loading bird Requests")
        }
    }

}

extension MyBirdRequestsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return birdRequests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let birdRequest = birdRequests[indexPath.item]
        let status = birdRequest.status.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyBirdRequestsCollectionViewCellId", for: indexPath) as! MyBirdRequestsCollectionViewCell
        cell.sentSinceTimeLabel.text = "Envoyée \(birdRequest.createdAt.toStringWithRelativeTime(strings: relativeTimeDict))"
        cell.questerProfilePicImageView.sd_setImage(with: birdRequest.questerProfilePicUrl, completed: nil)
        cell.requestWeightLabel.text = "\(birdRequest.weight) kg"
        cell.questerNameLabel.text = "QuesterName"
        cell.requestStatusDescriptionLabel.text = requestStatusDescriptions[status]
        cell.requestStatusImageView.image = requestIconViews[status]
        cell.backgroundColor = requestColors[status]
        
        return cell
    }
}

extension MyBirdRequestsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 124)
    }
}

extension MyBirdRequestsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let myRequest = birdRequests[indexPath.item]
        print(myRequest.status)
    }
}
