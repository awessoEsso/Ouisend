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
    
    var dateToUse: Date = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
        let date = dateFormatter.date(from: "2019-02-20") ?? Date()
        return date
    }()
    
    var myBirds: [Bird] = [Bird]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        FirebaseManager.shared.birds(with: { (birds) in
            self.myBirds = birds
            self.myBirdsCollectionView.reloadData()
        }) { (error) in
            print(error?.localizedDescription ?? "Error loading birds")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        switch destination {
        case is CreateBirdViewController:
            let createBirdViewController = destination as! CreateBirdViewController
            createBirdViewController.delegate = self
        default:
            print("Unknown")
        }
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
        cell.birdWeightLabel.text = "\(myBird.birdWeight) (3 kg réservés)"
        cell.requestNumberLabel.text = "3"
        
        
        return cell
    }
}

extension MyBirdsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth:CGFloat = collectionView.frame.width
        let cellHeight:CGFloat = 120
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension MyBirdsViewController: CreateBirdViewControllerDelegate {
    func didCreateBird(_ bird: Bird) {
        self.myBirds.append(bird)
        myBirdsCollectionView.reloadData()
    }
    
    
}
