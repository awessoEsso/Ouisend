//
//  HomeViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 22/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookLogin
import SDWebImage
import AFDateHelper

class HomeViewController: UIViewController {
    
    var dateToUse: Date = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
        let date = dateFormatter.date(from: "2019-02-20") ?? Date()
        return date
    }()
    
    @IBOutlet weak var emptyListLabel: UILabel!
    
    
    @IBOutlet weak var birdsCollectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    
    
    var birds: [Bird] =  [Bird]()
    
    var birder = Datas.shared.birder
    
    var selectedBird: Bird!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.birdsCollectionView.refreshControl = refreshControl
        
        refreshControl.tintColor = UIColor.white
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshBirdsData(_:)), for: .valueChanged)

        
        FirebaseManager.shared.birds(with: { (birds) in
            if birds.count == 0 {
                self.emptyListLabel.isHidden = false
            }
            self.birds = birds
            self.birdsCollectionView.reloadData()
        }) { (error) in
            print(error?.localizedDescription ?? "Error loading birds")
            self.emptyListLabel.isHidden = false
            self.emptyListLabel.text = "Sorry 😪, an error occured!!! "
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        switch destination {
        case is BirdViewController:
            let birdViewController = destination as! BirdViewController
            birdViewController.bird = self.selectedBird
        default:
            print("Unknown Segue")
        }
    }
    
    @objc private func refreshBirdsData(_ sender: Any) {
        // Fetch Birds Data
        FirebaseManager.shared.birdsObserveSingle(with: { (birds) in
            if birds.count == 0 {
                self.emptyListLabel.isHidden = false
            }
            self.birds = birds
            self.birdsCollectionView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error) in
            print(error?.localizedDescription ?? "Error loading birds")
             self.refreshControl.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
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

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bird = birds[indexPath.item]
        if bird.creator != birder?.identifier {
            self.selectedBird = bird
            performSegue(withIdentifier: "showBirdDetailsId", sender: nil)
        }
       
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth:CGFloat = collectionView.frame.width
        let cellHeight:CGFloat = 180
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

let relativeTimeDict: [RelativeTimeStringType: String] = [
    RelativeTimeStringType.nowPast : "à l'instant",
    RelativeTimeStringType.nowFuture : "dans quelques instants",
    RelativeTimeStringType.secondsPast: "il y a quelques secondes",
    RelativeTimeStringType.secondsFuture: "dans quelques secondes",
    RelativeTimeStringType.oneMinutePast: "il y a une minute",
    RelativeTimeStringType.oneMinuteFuture: "dans une minute",
    RelativeTimeStringType.minutesPast: "il y a %.f minutes",
    RelativeTimeStringType.minutesFuture: "dans %.f minutes",
    RelativeTimeStringType.oneHourPast: "il y a une heure",
    RelativeTimeStringType.oneHourFuture: "dans une heure",
    RelativeTimeStringType.hoursPast: "il y a %.f heures",
    RelativeTimeStringType.hoursFuture: "dans %.f heures",
    RelativeTimeStringType.oneDayPast: "il y a une journée",
    RelativeTimeStringType.oneDayFuture: "demain",
    RelativeTimeStringType.daysPast: "il y a %.f jours",
    RelativeTimeStringType.daysFuture: "dans %.f jours",
    RelativeTimeStringType.oneWeekPast: "la semaine dernière",
    RelativeTimeStringType.oneWeekFuture: "la semaine prochaine",
    RelativeTimeStringType.weeksPast: "il y a %.f semaines",
    RelativeTimeStringType.weeksFuture: "dans %.f semaines",
    RelativeTimeStringType.oneMonthPast: "il y a un mois",
    RelativeTimeStringType.oneMonthFuture: "dans un mois",
    RelativeTimeStringType.monthsPast: "il y a %.f mois",
    RelativeTimeStringType.monthsFuture: "dans %.f mois",
    RelativeTimeStringType.oneYearPast: "l'année dernière",
    RelativeTimeStringType.oneYearFuture: "l' année prochaine",
    RelativeTimeStringType.yearsPast: "il y a %.f années",
    RelativeTimeStringType.yearsFuture: "dans %.f années"
]
