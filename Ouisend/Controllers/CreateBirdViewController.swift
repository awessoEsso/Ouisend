//
//  CreateBirdViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 24/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import Eureka
import NVActivityIndicatorView
import SCLAlertView

let ouiSendBlueColor = UIColor(red: 16/255, green: 82/255, blue: 150/255, alpha: 1)

class CreateBirdViewController: FormViewController {
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    var countries = Datas.shared.countries
    
    var cities = Datas.shared.cities
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: view.frame.width/2 - 40, y: view.frame.height/2 - 40), size: CGSize(width: 80, height: 80)), type: NVActivityIndicatorType.init(rawValue: 30), color: ouiSendBlueColor, padding: 20)
        
        
        view.addSubview(activityIndicatorView)
        
        
        form +++ Section("Départ")
            
            <<< PickerInlineRow<String>("PaysDepart"){
                $0.tag = "cb_pays_depart"
                $0.title = "Pays Départ"
                if countries?.isEmpty == true {
                    FirebaseManager.shared.countries(with: { (countries) in
                        
                    }) { (error) in
                        print(error ?? "error loading countries")
                    }
                }
                else {
                    if let countries = countries {
                        $0.options = countries.map { $0.name ?? "" }
                        //$0.value = countries.first?.name ?? ""
                    }
                    
                }
                
                $0.add(rule: RuleRequired())
                
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
            
            <<< DateRow(){
                $0.tag = "cb_date_depart"
                $0.title = "Date départ"
                $0.value = Date()
        }
        
        
        form +++ Section("Arrivée")
            
            <<< PickerInlineRow<String>("PaysArrivee"){
                $0.tag = "cb_pays_arrivee"
                $0.title = "Pays Arrivée"
                if countries?.isEmpty == true {
                    FirebaseManager.shared.countries(with: { (countries) in
                        
                    }) { (error) in
                        print(error ?? "error loading countries")
                    }
                }
                else {
                    if let countries = countries {
                        $0.options = countries.map { $0.name ?? "" }
                        //$0.value = countries.first?.name ?? ""
                    }
                    
                }
                
                $0.add(rule: RuleRequired())
                
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
                $0.value = Date()
        }
        
        
        form +++ Section("Offre")
            
            <<< IntRow(){ row in
                row.tag = "cb_bird_weight"
                row.title = "Poids à vendre"
                row.value = 0
            }
            
            <<< SwitchRow() {
                $0.tag = "cb_bird_perkilo"
                $0.title = "Prix par kg?"
                $0.value = false
            }
            
            <<< IntRow(){ row in
                row.tag = "cb_bird_price"
                row.title = "Prix"
                row.value = 0
            }
            
            
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Soumettre"
                }
                .onCellSelection { cell, row in
                    
                    self.activityIndicatorView.startAnimating()
                    self.view.isUserInteractionEnabled = false
                    
                    let errors = self.form.validate()
                    if ( errors.isEmpty == true ){
                        let values = self.form.values()
                        print(values)
                        self.handleFormValues(values)
                    }
                    else {
                        print(errors)
                        self.activityIndicatorView.stopAnimating()
                    }
        }
    }
    
    func handleFormValues( _ values: [String: Any?]) {
        guard let birder = Datas.shared.birder else { return }
        var birdDictionnary = values
        birdDictionnary["birderName"] = birder.displayName ?? ""
        birdDictionnary["birderProfilePicUrl"] = birder.photoURL?.absoluteString ?? ""
        
        let bird = Bird(dictionnary: birdDictionnary)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.createBird(bird)
        })
    }
    
    func createBird(_ bird: Bird) {
        FirebaseManager.shared.createBird(bird, success: {
            print("Bird Registred successfully")
            self.handleBirdCreationSucceed()
        }) { (error) in
            print(error ?? "Error creating bird")
            self.activityIndicatorView.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func handleBirdCreationSucceed() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Fermer", backgroundColor: ouiSendBlueColor, textColor: .white) {
            self.navigationController?.popViewController(animated: true)
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
