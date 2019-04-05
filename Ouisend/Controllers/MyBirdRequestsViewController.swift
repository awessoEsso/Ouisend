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
    
    private let refreshControl = UIRefreshControl()
    
    var bird: Bird!
    
    var selectedRequest: Request?
    
    @IBOutlet weak var emptyLabel: UILabel!
    
    var birdRequests = [Request]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "\(bird.departureCity)  -  \(bird.arrivalCity)"
        
        tabBarController?.tabBar.isHidden = true
        
        self.myBirdRequestsCollectionView.refreshControl = refreshControl
        
        refreshControl.tintColor = ouiSendBlueColor
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshBirdRequestsData(_:)), for: .valueChanged)
        
        FirebaseManager.shared.birdRequests(with: bird.identifier, success: { (birdRequests) in
            if birdRequests.count == 0 {
                self.emptyLabel.isHidden = false
            }
            self.birdRequests = birdRequests
            self.myBirdRequestsCollectionView.reloadData()
        }) { (error) in
            print(error?.localizedDescription ?? "Error loading bird Requests")
        }
    }
    
    @objc private func refreshBirdRequestsData(_ sender: Any) {
        // Fetch Bird Requeuests Data
        FirebaseManager.shared.birdRequestsObserveSingle(with: bird.identifier, success: { (birdRequests) in
            if birdRequests.count == 0 {
                self.emptyLabel.isHidden = false
            }
            self.birdRequests = birdRequests
            self.myBirdRequestsCollectionView.reloadData()
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
                    ouiChatViewController.destinataireName = selectedRequest.questerName
                    ouiChatViewController.destinataireId = selectedRequest.creator
                    ouiChatViewController.destinataireUrl = selectedRequest.questerProfilePicUrl
                }
                
            }
            
        default:
            print("Unknown")
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
        //cell.delegate = self
        cell.sentSinceTimeLabel.text = "Envoyée \(birdRequest.createdAt.toStringWithRelativeTime(strings: relativeTimeDict))"
        cell.questerProfilePicImageView.sd_setImage(with: birdRequest.questerProfilePicUrl, completed: nil)
        cell.requestWeightLabel.text = "\(birdRequest.weight) kg"
        cell.questerNameLabel.text = birdRequest.questerName
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
        self.selectedRequest = myRequest
        
        if myRequest.status == .accepted {
            performSegue(withIdentifier: "openOuiChatViewControllerId", sender: nil)
        }
        else {
           showActionSheet()
        }
        
    }
    
    func answerRequest(request: Request, accepted: Bool) {
        if accepted {
            FirebaseManager.shared.acceptRequest(request)
        }
        else {
            FirebaseManager.shared.declineRequest(request)
        }
        let message = accepted ? "Votre demande a été acceptée" : "Votre demande a été refusée"
        self.sendNotifToRequestCreator(message: message, creatorId: request.creator)
        self.refreshBirdRequestsData(request)
    }
    
    func sendNotifToRequestCreator(message: String, creatorId: String) {
        FirebaseManager.shared.tokenForUser(with: creatorId, success: { (creatorToken) in
            FirebaseManager.shared.createOneToOneNotification(message, token: creatorToken)
        }) { (error) in
            print(error?.localizedDescription ?? "Error getting Request creator token")
        }
        
    }
    
    func showActionSheet() {
        
        guard let selectedRequest = selectedRequest else { return }
        
        let optionMenu = UIAlertController(title: nil, message: "Repondre", preferredStyle: .actionSheet)
        
        let declineAction = UIAlertAction(title: "Refuser", style: .destructive) { (action) in
            self.answerRequest(request: selectedRequest, accepted: false)
        }
        let acceptAction = UIAlertAction(title: "Accepter", style: .default){ (action) in
           self.answerRequest(request: selectedRequest, accepted: true)
        }
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel)
        
        optionMenu.addAction(declineAction)
        optionMenu.addAction(acceptAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
}
