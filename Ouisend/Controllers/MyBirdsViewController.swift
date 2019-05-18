//
//  MyBirdsViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 24/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class MyBirdsViewController: UIViewController {
    
    @IBOutlet weak var myBirdsCollectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    
    var myBirds: [Bird] = [Bird]()
    
    var birdSelected: Bird!
    
    @IBOutlet weak var filteringSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var emptyListLabel: UILabel!
    
    var filterIsUpComing = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.myBirdsCollectionView.refreshControl = refreshControl
        
        refreshControl.tintColor = UIColor.Blue.ouiSendBlueColor
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshBirdsData(_:)), for: .valueChanged)
        
       refreshBirdsData(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshBirdsData(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func filteringChanged(_ sender: UISegmentedControl) {
        filterIsUpComing = (filteringSegmentedControl.selectedSegmentIndex == 0)
        refreshBirdsData(self)
    }
    
    
    @objc private func refreshBirdsData(_ sender: Any) {
        // Fetch Birds Data
        self.refreshControl.beginRefreshing()
        if (filterIsUpComing) {
            loadUpcomingBirds()
        }
        else {
            loadOldBirds()
        }
    }
    
    func loadOldBirds() {
        FirebaseManager.shared.myOldBirdsObserveSingle(with: { (birds) in
            if birds.count == 0 {
                self.emptyListLabel.isHidden = false
            }
            else {
                self.emptyListLabel.isHidden = true
            }
            self.myBirds = birds
            self.myBirdsCollectionView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error) in
            print(error?.localizedDescription ?? "Error loading birds")
            self.refreshControl.endRefreshing()
        }
    }
    
    func loadUpcomingBirds() {
        FirebaseManager.shared.myUpcomingBirdsObserveSingle(with: { (birds) in
            if birds.count == 0 {
                self.emptyListLabel.isHidden = false
            }
            else {
                self.emptyListLabel.isHidden = true
            }
            self.myBirds = birds
            self.myBirdsCollectionView.reloadData()
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
            if let createBirdViewController = navigationController.viewControllers.first as? CreateBirdViewController {
                createBirdViewController.delegate = self
            }
            
        case is CreateBirdViewController:
            let createBirdViewController = destination as! CreateBirdViewController
            createBirdViewController.delegate = self
            
        case is CreatorBirdViewController:
            let creatorBirdViewController = destination as! CreatorBirdViewController
            creatorBirdViewController.bird = birdSelected
            
        case is MyBirdRequestsViewController:
            let myBirdRequestsViewController = destination as! MyBirdRequestsViewController
            myBirdRequestsViewController.bird = self.birdSelected
            //myBirdRequestsViewController.delegate = self
        default:
            print("Unknown")
        }
    }
    

}

extension MyBirdsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.birdSelected = myBirds[indexPath.item]
        performSegue(withIdentifier: "showCreatorBirdSegueId", sender: nil)
    }
    
}

extension MyBirdsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myBirds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myBird = myBirds[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mybirdcollectionviewcellid", for: indexPath) as! MyBirdCollectionViewCell
        cell.travelDescriptionLabel.text = "\(myBird.departureCity) - \(myBird.arrivalCity)"
        cell.travelDateLabel.text = FrenchDateFormatter.formatDate(myBird.departureDate)
        
        var weightAccepted = 0
        for (_, value) in myBird.accepted {
            weightAccepted += value
        }
        cell.birdWeightLabel.text = "\(myBird.birdWeight) (\(weightAccepted) kg réservés)"
        cell.requestNumberLabel.text = "\(myBird.accepted.count)"
        cell.delegate = self
        
        return cell
    }
}

extension MyBirdsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth:CGFloat = collectionView.frame.width
        let cellHeight:CGFloat = 124
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension MyBirdsViewController: CreateBirdViewControllerDelegate {
    func didCreateBird(_ bird: Bird) {
        self.myBirds.append(bird)
        myBirdsCollectionView.reloadData()
    }
}

extension MyBirdsViewController: MyBirdCollectionViewCellDelegate {
    func showDetails(cell: MyBirdCollectionViewCell) {
        if let indexSelected = myBirdsCollectionView.indexPath(for: cell) {
             self.birdSelected = myBirds[indexSelected.item]
            performSegue(withIdentifier: "showMyBirdRequestsId", sender: nil)
        }
    }
}
