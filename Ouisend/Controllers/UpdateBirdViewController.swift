//
//  UpdateBirdViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 10/04/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import Eureka
import NVActivityIndicatorView
import SCLAlertView
import SwiftDate


protocol UpdateBirdViewControllerDelegate {
    func didUpdateBird(_ bird: Bird)
}

class UpdateBirdViewController: FormViewController {
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    var cities = Datas.shared.cities
    
    var delegate: UpdateBirdViewControllerDelegate?
    
    var bird: Bird!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: view.frame.width/2 - 40, y: view.frame.height/2 - 40), size: CGSize(width: 80, height: 80)), type: .orbit, color: UIColor.Blue.ouiSendBlueColor, padding: 20)
        
        
        view.addSubview(activityIndicatorView)
        
        
        form +++ Section("Départ")
            
            <<< PickerInlineRow<String>("VilleDepart"){ row in
                row.tag = "cb_ville_depart"
                row.title = "Ville Départ"
                row.value = bird.departureCity
                row.disabled = true
            }
            
            
            <<< DateRow(){
                $0.tag = "cb_date_depart"
                $0.title = "Date départ"
                $0.value = bird.departureDate
                $0.minimumDate = Date() + 1.days
                }
                .onChange { row in
                    guard let departureDate = row.value else { return }
                    if let arrivalDateRow = self.form.rowBy(tag: "cb_date_arrivee") as? DateRow {
                        arrivalDateRow.minimumDate = departureDate + 1.days
                        arrivalDateRow.reload()
                    }
        }
        
        
        form +++ Section("Arrivée")
            
            
            <<< PickerInlineRow<String>("VilleArrivee"){ row in
                row.tag = "cb_ville_arrivee"
                row.title = "Ville Arrivée"
                row.value = bird.arrivalCity
                row.disabled = true
            }
            
            <<< DateRow(){
                $0.tag = "cb_date_arrivee"
                $0.title = "Date arrivée"
                $0.value = bird.arrivalDate
                $0.minimumDate = Date() + 1.days
        }
        
        
        form +++ Section("Offre")
            
            <<< IntRow(){ row in
                row.tag = "cb_bird_weight"
                row.title = "Poids à vendre"
                row.value = bird.birdWeight
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
                row.value = bird.birdPricePerKilo
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
                row.value = bird.birdTotalPrice
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
                $0.value = bird.currency
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
    
    
    func handleFormValues( _ values: [String: Any?]) {
        bird.departureDate = values["cb_date_depart"] as? Date ?? Date()
        bird.arrivalDate = values["cb_date_arrivee"] as? Date ?? Date()
        bird.birdWeight = values["cb_bird_weight"] as? Int ?? 0
        bird.birdTotalPrice = values["cb_bird_total_price"] as? Int ?? 0
        bird.birdPricePerKilo = values["cb_bird_price_per_k"] as? Int ?? 0
        bird.currency = values["cb_currency"] as? String ?? ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.updateBird()
        })
    }
    
    func updateBird() {
        FirebaseManager.shared.updateBird(bird, success: { (newBird) in
            print("Bird updated successfully")
            self.delegate?.didUpdateBird(newBird)
            self.handleBirdUpdateSucceed()
        }) { (error) in
            print(error ?? "Error creating bird")
            self.activityIndicatorView.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func handleBirdUpdateSucceed() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Fermer", backgroundColor: UIColor.Blue.ouiSendBlueColor, textColor: .white) {
            self.navigationController?.popViewController(animated: true)
        }
        alertView.showInfo("Félicitations", subTitle: "Votre Bird a été mis à jour avec succès")
        activityIndicatorView.stopAnimating()
        view.isUserInteractionEnabled = true
    }

}
