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

let ouiSendBlueColor = UIColor(red: 16/255, green: 82/255, blue: 150/255, alpha: 1)

protocol CreateBirdViewControllerDelegate {
    func didCreateBird(_ bird: Bird)
}

class CreateBirdViewController: FormViewController {
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    var countries = Datas.shared.countries
    
    var cities = Datas.shared.cities
    
    var delegate: CreateBirdViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: view.frame.width/2 - 40, y: view.frame.height/2 - 40), size: CGSize(width: 80, height: 80)), type: NVActivityIndicatorType.init(rawValue: 30), color: ouiSendBlueColor, padding: 20)
        
        
        view.addSubview(activityIndicatorView)
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            cell.textLabel?.textAlignment = .right
            
        }
        
        
        form +++ Section("Départ")
            
            <<< PickerInlineRow<String>("PaysDepart"){ row in
                row.tag = "cb_pays_depart"
                row.title = "Pays Départ"
                if countries?.isEmpty == true {
                    FirebaseManager.shared.countries(with: { (countries) in
                        row.options = countries.map { $0.name ?? "" }
                    }) { (error) in
                        print(error ?? "error loading countries")
                    }
                }
                else {
                    if let countries = countries {
                        row.options = countries.map { $0.name ?? "" }
                    }
                }
                
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesAlways
                
                }.onChange { row in
                    
                    guard let countryName = row.value else { return }
                    if let departureCityRow = self.form.rowBy(tag: "cb_ville_depart") as? PickerInlineRow<String> {
                        let citiesNames = self.cities(for: countryName)
                        departureCityRow.options = citiesNames
                        if citiesNames.count > 0 {
                            departureCityRow.value = citiesNames[0]
                        }
                        departureCityRow.reload() // not sure if needed
                    }
            }
            
            <<< PickerInlineRow<String>("VilleDepart"){
                $0.tag = "cb_ville_depart"
                $0.title = "Ville Départ"
                }
                .cellUpdate { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
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
            
            <<< PickerInlineRow<String>("PaysArrivee"){ row in
                row.tag = "cb_pays_arrivee"
                row.title = "Pays Arrivée"
                if countries?.isEmpty == true {
                    FirebaseManager.shared.countries(with: { (countries) in
                        row.options = countries.map { $0.name ?? "" }
                    }) { (error) in
                        print(error ?? "error loading countries")
                    }
                }
                else {
                    if let countries = countries {
                        row.options = countries.map { $0.name ?? "" }
                    }
                }
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                
                }.onChange { row in
                    guard let countryName = row.value else { return }
                    if let arrivalCityRow = self.form.rowBy(tag: "cb_ville_arrivee") as? PickerInlineRow<String> {
                        let citiesNames = self.cities(for: countryName)
                        arrivalCityRow.options = citiesNames
                        if citiesNames.count > 0 {
                            arrivalCityRow.value = citiesNames[0]
                        }
                        arrivalCityRow.reload() // not sure if needed
                    }
            }
            
            
            <<< PickerInlineRow<String>("VilleArrivee"){
                $0.tag = "cb_ville_arrivee"
                $0.title = "Ville Arrivée"
            }
            
            <<< DateRow(){
                $0.tag = "cb_date_arrivee"
                $0.title = "Date arrivée"
                $0.value = Date() + 2.days
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
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func handleFormValues( _ values: [String: Any?]) {
        guard let birder = Datas.shared.birder else { return }
        var birdDictionnary = values
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
        alertView.addButton("Fermer", backgroundColor: ouiSendBlueColor, textColor: .white) {
            self.dismiss(animated: true, completion: nil)
        }
        alertView.showInfo("Félicitations", subTitle: "Votre Bird a été créé avec succès")
        activityIndicatorView.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    
    
    func cities(for countryName: String) -> [String] {
        if let filteredCities = cities?.filter({ $0.countryName == countryName }) {
            return filteredCities.map { $0.name ?? "" }
        }
        return [String]()
    }
}
