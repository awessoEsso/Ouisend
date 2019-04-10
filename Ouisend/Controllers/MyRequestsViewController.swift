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
    
    private let refreshControl = UIRefreshControl()
    
    var myRequests = [Request]()
    
    var selectedRequest: Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.requestsCollectionView.refreshControl = refreshControl
        
        refreshControl.tintColor = UIColor.Blue.ouiSendBlueColor
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshRequestsData(_:)), for: .valueChanged)
        
        FirebaseManager.shared.myRequests({ (requests) in
            self.myRequests = requests
            self.requestsCollectionView.reloadData()
        }) { (error) in
            print(error?.localizedDescription ?? "Error loading Requests")
        }
        
    }
    
    @objc private func refreshRequestsData(_ sender: Any) {
        // Fetch Birds Data
        FirebaseManager.shared.myRequestsObserveSingle({ (requests) in
            self.myRequests = requests
            self.requestsCollectionView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error) in
            print(error?.localizedDescription ?? "Error loading birds")
            self.refreshControl.endRefreshing()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        switch destination {
            
        case is UINavigationController:
            let navigationController = destination as! UINavigationController
            if let ouiChatViewController = navigationController.viewControllers.first as? OuiChatViewController {
                if let selectedRequest = selectedRequest {
                    ouiChatViewController.destinataireName = selectedRequest.birderName
                    ouiChatViewController.destinataireId = selectedRequest.birderId
                    ouiChatViewController.destinataireUrl = selectedRequest.birderProfilePicUrl
                }
                
            }
            
        default:
            print("Unknown")
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
        if status == 3 {
            let acceptedCell = self.collectionView(collectionView, acceptedCellForItemAt: indexPath)
            return acceptedCell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyRequestCollectionViewCellId", for: indexPath) as! MyRequestCollectionViewCell
            
            cell.travelDescriptionLabel.text = "\(myRequest.departureCity) - \(myRequest.arrivalCity) "
            cell.weightLabel.text = "\(myRequest.weight) Kg"
            cell.departureDateLabel.text = FrenchDateFormatter.formatDate(myRequest.departureDate)
            cell.birderProfilePicImageView.sd_setImage(with: myRequest.birderProfilePicUrl, completed: nil)
            cell.birdStatusDescriptionLabel.text = requestStatusDescriptions[status]
            cell.backgroundColor = requestColors[status]
            cell.birdStatusImageView.image = requestIconViews[status]
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, acceptedCellForItemAt indexPath: IndexPath) -> AcceptedRequestCollectionViewCell {
        let myRequest = myRequests[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AcceptedRequestCollectionViewCellId", for: indexPath) as! AcceptedRequestCollectionViewCell
        
        cell.delegate = self
        
        cell.travelDescriptionLabel.text = "\(myRequest.departureCity) - \(myRequest.arrivalCity) "
        cell.weightLabel.text = "\(myRequest.weight) Kg"
        cell.departureDateLabel.text = FrenchDateFormatter.formatDate(myRequest.departureDate)
        cell.birderProfilePicImageView.sd_setImage(with: myRequest.birderProfilePicUrl, completed: nil)
        cell.birdStatusDescriptionLabel.text = requestStatusDescriptions[3]
        cell.birdStatusImageView.image = requestIconViews[3]
        
        return cell
    }
    
}

extension MyRequestsViewController: AcceptedRequestCollectionViewCellDelegate {
    func writeToBirder(cell: AcceptedRequestCollectionViewCell) {
        
        if let indexPath = requestsCollectionView.indexPath(for: cell) {
            let myRequest = myRequests[indexPath.item]
            if myRequest.status == .accepted {
                selectedRequest = myRequest
                performSegue(withIdentifier: "ouiChatViewControllerId", sender: nil)
            }
        }
        
    }
}

extension MyRequestsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let myRequest = myRequests[indexPath.item]
        if myRequest.status == .accepted {
            selectedRequest = myRequest
            performSegue(withIdentifier: "ouiChatViewControllerId", sender: nil)
        }
    }
}

extension MyRequestsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let myRequest = myRequests[indexPath.item]
        let status = myRequest.status.rawValue
        
        if status == 3 {
            return CGSize(width: collectionView.frame.width - 32, height: 180)
        } else {
            return CGSize(width: collectionView.frame.width - 32, height: 120)
        }
    }
}

