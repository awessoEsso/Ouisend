//
//  SearchResultsViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 22/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit


class SearchResultsViewController: UIViewController {
    
    @IBOutlet weak var birdsCollectionView: UICollectionView!
    
    @IBOutlet weak var emptyListLabel: UILabel!
    
    private let refreshControl = UIRefreshControl()
    
    var birds: [Bird] =  [Bird]()
    
    var birder = Datas.shared.birder
    
    var selectedBird: Bird!
    
    var departureCity = ""
    
    var destinationCity = ""
    
    var searchCase: SearchCase = .all

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setTitle()

        refreshControl.tintColor = UIColor.Blue.ouiSendBlueColor

        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshBirdsData(_:)), for: .valueChanged)
        
        self.birdsCollectionView.refreshControl = refreshControl

        refreshControl.beginRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
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
    
    
    func setTitle() {
        switch searchCase {
        case .all:
            self.title = "\(departureCity)-\(destinationCity)"
        
        case .onlyDestination:
            self.title = "Destination: \(destinationCity)"
        
        case .onlyDeparture:
            self.title = "Depart: \(departureCity)"
        case .any:
            self.title = "Toutes les offres"
        }
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func refreshBirdsData(_ sender: Any) {
        // Fetch Birds Data
        reloadData()
    }
    
    func reloadData() {
        self.refreshControl.beginRefreshing()
        
        switch searchCase {
            
        case .all:
            self.title = "\(departureCity)-\(destinationCity)"
            FirebaseManager.shared.birdsObserveSingleWithDepartureAndDestination(departureCity: departureCity, destinationCity: destinationCity, success: { (birds) in
                self.reloadCollectionViewWithBirds(birds)
            }, failure: { (error) in
                print(error?.localizedDescription ?? "Error loading birds")
                self.refreshControl.endRefreshing()
            })
            
        case .onlyDestination:
            FirebaseManager.shared.birdsObserveSingleWithDestination(destinationCity: destinationCity, success: { (birds) in
                self.reloadCollectionViewWithBirds(birds)
            }, failure: { (error) in
                print(error?.localizedDescription ?? "Error loading birds")
                self.refreshControl.endRefreshing()
            })
            
        case .onlyDeparture:
            FirebaseManager.shared.birdsObserveSingleWithDeparture(departureCity: departureCity, success: { (birds) in
                self.reloadCollectionViewWithBirds(birds)
            }, failure: { (error) in
                print(error?.localizedDescription ?? "Error loading birds")
                self.refreshControl.endRefreshing()
            })
        case .any:
            FirebaseManager.shared.birds(with: { (birds) in
                self.reloadCollectionViewWithBirds(birds)
            }) { (error) in
                print(error?.localizedDescription ?? "Error loading birds")
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func reloadCollectionViewWithBirds(_ birds: [Bird]) {
        if birds.count == 0 {
            self.emptyListLabel.isHidden = false
        }
        self.birds = birds
        self.birdsCollectionView.reloadData()
        self.refreshControl.endRefreshing()
    }
    

    
}


extension SearchResultsViewController: UICollectionViewDataSource {
    
    
    
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

extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bird = birds[indexPath.item]
//        if bird.creator != birder?.identifier {
//            self.selectedBird = bird
//            performSegue(withIdentifier: "showBirdDetailsId", sender: nil)
//        }
        
        
        self.selectedBird = bird
        performSegue(withIdentifier: "showBirdDetailsId", sender: nil)
        
    }
}

extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth:CGFloat = collectionView.frame.width
        let cellHeight:CGFloat = 180
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

