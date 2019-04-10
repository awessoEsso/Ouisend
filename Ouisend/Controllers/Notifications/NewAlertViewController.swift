//
//  NewAlertViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 09/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import Eureka
import NVActivityIndicatorView
import SCLAlertView

protocol NewAlertViewControllerDelegate {
    func didCreateTopic(_ topicJoin: TopicJoin)
}

class NewAlertViewController: FormViewController {
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    var countries = Datas.shared.countries
    
    var cities = Datas.shared.cities
    
    var delegate: NewAlertViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: view.frame.width/2 - 40, y: view.frame.height/2 - 40), size: CGSize(width: 80, height: 80)), type: .orbit, color: UIColor.Blue.ouiSendBlueColor, padding: 20)
        
        
        view.addSubview(activityIndicatorView)
        
        
        form +++ Section("Départ")
            
            <<< PickerInlineRow<String>("PaysDepart"){
                $0.tag = "na_pays_depart"
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
                    if let departureCityRow = self.form.rowBy(tag: "na_ville_depart") as? PickerInlineRow<String> {
                        let citiesNames = self.cities(for: countryName)
                        departureCityRow.options = citiesNames
                        if citiesNames.count > 0 {
                            departureCityRow.value = citiesNames[0]
                        }
                        departureCityRow.reload() // not sure if needed
                    }
            }
            
            <<< PickerInlineRow<String>("VilleDepart"){
                $0.tag = "na_ville_depart"
                $0.title = "Ville Départ"
        }
        
        
        
        
        form +++ Section("Arrivée")
            
            <<< PickerInlineRow<String>("PaysArrivee"){
                $0.tag = "na_pays_arrivee"
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
                    }
                    
                }
                
                $0.add(rule: RuleRequired())
                
                }.onChange { row in
                    guard let countryName = row.value else { return }
                    if let arrivalCityRow = self.form.rowBy(tag: "na_ville_arrivee") as? PickerInlineRow<String> {
                        let citiesNames = self.cities(for: countryName)
                        arrivalCityRow.options = citiesNames
                        if citiesNames.count > 0 {
                            arrivalCityRow.value = citiesNames[0]
                        }
                        arrivalCityRow.reload() // not sure if needed
                    }
            }
            
            <<< PickerInlineRow<String>("VilleArrivee"){
                $0.tag = "na_ville_arrivee"
                $0.title = "Ville Arrivée"
        }
        
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Enregistrer"
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
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func handleFormValues( _ values: [String: Any?]) {
        guard let birder = Datas.shared.birder else { return }
        let creator = birder.identifier
        var topicDictionnary = values
        let departureCity = values["na_ville_depart"] as? String ?? ""
        let arrivalCity = values["na_ville_arrivee"] as? String ?? ""
        let identifier = topicIdentifier(citiesName: [departureCity, arrivalCity])
        topicDictionnary["identifier"] = identifier
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.createTopic(identifier: identifier, departureCity: departureCity, arrivalCity: arrivalCity, creator: creator)
        })
    }
    
    func createTopic( identifier: String, departureCity: String, arrivalCity: String, creator: String) {
        
        FirebaseManager.shared.createTopic(identifier, departureCity: departureCity, arrivalCity: arrivalCity, creator: creator, success: {
            print("Topic Registred successfully")
            let name = "\(departureCity) - \(arrivalCity)"
            let topicJoin = TopicJoin(identifier: identifier, name: name)
            self.delegate?.didCreateTopic(topicJoin)
            self.handleTopicCreationSucceed()
            FIRMessagingService.shared.subscribe(to: identifier)
        }) { (error) in
            print(error ?? "Error creating topic")
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
    
    func handleTopicCreationSucceed() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Fermer", backgroundColor: UIColor.Blue.ouiSendBlueColor, textColor: .white) {
            self.dismiss(animated: true, completion: nil)
        }
        alertView.showInfo("Félicitations", subTitle: "Votre Topic a été créé avec succès")
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
