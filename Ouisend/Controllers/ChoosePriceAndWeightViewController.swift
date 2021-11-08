//
//  ChoosePriceAndWeightViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 01/06/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import NVActivityIndicatorView

class ChoosePriceAndWeightViewController: UIViewController {
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var pricePerKiloWeightTextField: UITextField!
    
    @IBOutlet weak var totalPriceTextField: UITextField!
    
    var departureCity: City?
    
    var destinationCity: City?
    
    var departureDate: Date!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: view.frame.width/2 - 40, y: view.frame.height/2 - 40), size: CGSize(width: 80, height: 80)), type: .orbit, color: UIColor.Blue.ouiSendBlueColor, padding: 20)
        
        view.addSubview(activityIndicatorView)
        
        self.hideKeyboardWhenTappedAround() 
    }
    
    @IBAction func createBirdAction(_ sender: UIButton) {
        
        if weightTextField.text?.isEmpty == false {
            if pricePerKiloWeightTextField.text?.isEmpty == false {
                if totalPriceTextField.text?.isEmpty == false {
                    saveBird()
                }
                else {
                    SCLAlertView().showError("Erreur", subTitle: "Veuillez renseigner le prix du poids total disponible svp.")
                }
            }
            else {
                SCLAlertView().showError("Erreur", subTitle: "Veuillez renseigner le prix par kilo svp.")
            }
        }
        else {
            SCLAlertView().showError("Erreur", subTitle: "Veuillez renseigner le poids disponible svp.")
        }
    }
    
    func saveBird() {
        let weightAvailable = Int(weightTextField.text ?? "0")!
        let pricePerKilo = Int(pricePerKiloWeightTextField.text ?? "0")!
        let totalPrice = Int(totalPriceTextField.text ?? "0")!
        
        var birder = Datas.shared.birder
        
        activityIndicatorView.startAnimating()
        
        if birder == nil {
            if let currentUSer = Auth.auth().currentUser {
                birder = Birder(user: currentUSer)
            }
            else {
                self.handleBirdCreationFailed()
            }
        }
        
        let bird = Bird(birdTravelerName: birder?.displayName, birdTravelerProfilePic: birder?.photoURL?.absoluteString, departureCity: departureCity!.name!, departureDate: departureDate, arrivalCity: destinationCity!.name!, birdWeight: weightAvailable, birdTotalPrice: totalPrice, birdPricePerKilo: pricePerKilo, creator: birder!.identifier)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.createBird(bird)
        })
        
        
    }
    
    func createBird(_ bird: Bird) {
        
        FirebaseManager.shared.createBird(bird, success: { (newBird) in
            self.handleBirdCreationSucceed()
            print("Bird Registred successfully")
        }) { (error) in
            self.handleBirdCreationFailed()
        }
    }
    
    func resetForm() {
        let rootViewController = navigationController?.viewControllers.first as! NewCreateBirdViewController
        rootViewController.resetForm()
        navigationController?.popToRootViewController(animated: true)
    }
    
    func handleBirdCreationSucceed() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Voir mes birds", backgroundColor: UIColor.Blue.ouiSendBlueColor, textColor: .white) {
            self.resetForm()
        }
        alertView.showInfo("Félicitations", subTitle: "Votre Bird a été créé avec succès")
        activityIndicatorView.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    func handleBirdCreationFailed() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showError("Error", subTitle: "An error occured while creating bird")
        activityIndicatorView.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    
}
