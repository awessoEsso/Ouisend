//
//  CreateBirdViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 24/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import SwiftDate
import Eureka
import NVActivityIndicatorView
import SCLAlertView



protocol CreateBirdViewControllerDelegate {
    func didCreateBird(_ bird: Bird)
}

class CreateBirdViewController: FormViewController {
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    var countries = Datas.shared.countries
    
    var cities = Datas.shared.cities
    
    var delegate: CreateBirdViewControllerDelegate?
    
    var createdBird: Bird!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: view.frame.width/2 - 40, y: view.frame.height/2 - 40), size: CGSize(width: 80, height: 80)), type: .orbit, color: UIColor.Blue.ouiSendBlueColor, padding: 20)
        
        
        view.addSubview(activityIndicatorView)
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            cell.textLabel?.textAlignment = .right
            
        }
        
        
        form +++ Section("Départ")
            
            <<< PickerInlineRow<String>("VilleDepart"){ row in
                row.tag = "cb_ville_depart"
                row.title = "Ville Départ"
                if cities?.isEmpty == true {
                    FirebaseManager.shared.countries(with: { (cities) in
                        row.options = cities.map { $0.name ?? "" }
                    }) { (error) in
                        print(error ?? "error loading cities")
                    }
                }
                else {
                    if let cities = cities {
                        row.options = cities.map { $0.name ?? "" }
                    }
                }
                }
            
            
            <<< DateRow(){
                $0.tag = "cb_date_depart"
                $0.title = "Date départ"
                $0.value = Date() + 1.days
                $0.minimumDate = Date() + 1.days
                }
                .onChange { row in
                    guard let departureDate = row.value else { return }
                    if let arrivalDateRow = self.form.rowBy(tag: "cb_date_arrivee") as? DateRow {
                        arrivalDateRow.value = departureDate + 1.days
                        arrivalDateRow.minimumDate = departureDate + 1.days
                        arrivalDateRow.reload()
                    }
        }
        
        
        form +++ Section("Arrivée")
            
            
            <<< PickerInlineRow<String>("VilleArrivee"){ row in
                row.tag = "cb_ville_arrivee"
                row.title = "Ville Arrivée"
                
                if cities?.isEmpty == true {
                    FirebaseManager.shared.countries(with: { (cities) in
                        row.options = cities.map { $0.name ?? "" }
                    }) { (error) in
                        print(error ?? "error loading cities")
                    }
                }
                else {
                    if let cities = cities {
                        row.options = cities.map { $0.name ?? "" }
                    }
                }
            }
            
            <<< DateRow(){
                $0.tag = "cb_date_arrivee"
                $0.title = "Date arrivée"
                $0.value = Date() + 1.days
        }
        
        
        form +++ Section("Offre")
            
            <<< IntRow(){ row in
                row.tag = "cb_bird_weight"
                row.title = "Poids à vendre"
                row.placeholder = "23"
                row.add(rule: RuleRequired())
                row.add(rule: RuleGreaterThan(min: 5))
                row.add(rule: RuleSmallerThan(max: 200))
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< IntRow(){ row in
                row.tag = "cb_bird_price_per_k"
                row.title = "Prix par kilos"
                row.placeholder = "6"
                row.add(rule: RuleGreaterThan(min: 1))
                row.add(rule: RuleRequired())
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< IntRow(){ row in
                row.tag = "cb_bird_total_price"
                row.title = "Prix Total"
                row.placeholder = "120"
                row.add(rule: RuleGreaterThan(min: 1))
                row.add(rule: RuleRequired())
                //row.value = 0
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< PickerInlineRow<String>("Monnaie"){
                $0.tag = "cb_currency"
                $0.title = "Monnaie"
                $0.options = ["€", "$"]
                $0.value = "€"
                $0.add(rule: RuleRequired())
            }
            
            
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Soumettre"
                }
                .onCellSelection { cell, row in
                    let errors = self.form.validate()
                    if ( errors.isEmpty == true ){
                        self.activityIndicatorView.startAnimating()
                        self.view.isUserInteractionEnabled = false
                        let values = self.form.values()
                        print(values)
                        self.handleFormValues(values)
                    }
                    else {
                        print(errors)
                        SCLAlertView().showError("Error", subTitle: "Remplissez correctement tous les champs svp")
                        self.activityIndicatorView.stopAnimating()
                    }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        switch destination {
        case is CreatedBirdViewController:
            let createdBirdViewController = destination as! CreatedBirdViewController
            createdBirdViewController.bird = createdBird
        default:
            print("Unknown Segue")
        }
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func handleFormValues( _ values: [String: Any?]) {
        guard let birder = Datas.shared.birder else { return }
        var birdDictionnary = values
        let departureCityName = birdDictionnary["cb_ville_depart"] as? String ?? ""
        let arrivalCityName = birdDictionnary["cb_ville_arrivee"] as? String ?? ""
        birdDictionnary["cb_pays_depart"] = cityWithName(departureCityName)?.countryName
        birdDictionnary["cb_pays_arrivee"] = cityWithName(arrivalCityName)?.countryName
        birdDictionnary["creator"] = birder.identifier
        birdDictionnary["birderName"] = birder.displayName ?? ""
        birdDictionnary["birderProfilePicUrl"] = birder.photoURL?.absoluteString ?? ""
        
        
        let bird = Bird(dictionnary: birdDictionnary)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.createBird(bird)
        })
    }
    
    func createBird(_ bird: Bird) {
        
        FirebaseManager.shared.createBird(bird, success: { (newBird) in
            print("Bird Registred successfully")
            self.createdBird = newBird
            self.delegate?.didCreateBird(newBird)
            self.handleBirdCreationSucceed()
            self.sendTopicNotification(for: newBird)
        }) { (error) in
            print(error ?? "Error creating bird")
            self.activityIndicatorView.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func topicIdentifier(citiesName: [String]) -> String {
        var topicName: String = ""
        if citiesName.count == 2 {
            let names = citiesName.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            topicName = "\(names[0])-\(names[1])"
        }
        return topicName.replacingOccurrences(of: " ", with: "")
    }
    
    func sendTopicNotification(for bird: Bird) {
        let topicIdentifier = self.topicIdentifier(citiesName: [bird.departureCity, bird.arrivalCity])
        FirebaseManager.shared.createTopicNotificationForBird(bird, topic: topicIdentifier)
    }
    
    func handleBirdCreationSucceed() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Voir mes birds", backgroundColor: UIColor.Blue.ouiSendBlueColor, textColor: .white) {
            self.tabBarController?.selectedIndex = 1
            self.resetForm()
        }
        alertView.showInfo("Félicitations", subTitle: "Votre Bird a été créé avec succès")
        activityIndicatorView.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    
    func resetForm() {
        form.setValues([
            "cb_ville_depart" : nil,
            "cb_ville_arrivee" : nil,
            "cb_date_arrivee" : nil,
            "cb_date_depart" : nil,
            "cb_bird_weight" : nil,
            "cb_bird_total_price" : nil,
            "cb_bird_price_per_k" : nil,
            "cb_currency" : nil,
            
            ])
        
        tableView.reloadData()
    }
    
    
    func cityWithName(_ cityName: String) -> City? {
        return cities?.filter { $0.name == cityName}.first
    }
    
    func cities(for countryName: String) -> [String] {
        if let filteredCities = cities?.filter({ $0.countryName == countryName }) {
            return filteredCities.map { $0.name ?? "" }
        }
        return [String]()
    }
}
