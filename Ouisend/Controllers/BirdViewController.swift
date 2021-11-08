//
//  BirdViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 26/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SCLAlertView

class BirdViewController: UIViewController {
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    @IBOutlet weak var birderProfilePic: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var weightDesiredStackView: UIStackView!
    
    @IBOutlet weak var weightSlider: UISlider!
    
    @IBOutlet weak var weightDesiredLabel: UILabel!
    
    @IBOutlet weak var weightDesiredPriceLabel: UILabel!
    
    @IBOutlet weak var birderNameLabel: UILabel!
    
    @IBOutlet weak var publishedDateLabel: UILabel!
    
    @IBOutlet weak var birdDateLabel: UILabel!
    
    @IBOutlet weak var totalWeightLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var pricePerKiloLabel: UILabel!
    
    @IBOutlet weak var detailsTextView: UITextView!
    
    var weightValue: Int = 1
    
    var bird: Bird!
    
    var birder: Birder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        FirebaseManager.shared.user(with: bird.creator, success: { (birder) in
            self.birder = birder
        }) { (error) in
            print(error?.localizedDescription ?? "Error getting birder")
        }
        
        
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: view.frame.width/2 - 40, y: view.frame.height/2 - 40), size: CGSize(width: 80, height: 80)), type: NVActivityIndicatorType.orbit, color: UIColor.Blue.ouiSendBlueColor, padding: 20)
        
        view.addSubview(activityIndicatorView)
        
        title = "\(bird.departureCity)  -  \(bird.arrivalCity)"
        
        tabBarController?.tabBar.isHidden = true
        
        weightSlider.maximumValue = Float(bird.birdWeight)
        weightSlider.value = Float(weightValue)
        
        detailsTextView.delegate = self
        birderNameLabel.text = bird.birdTravelerName
        publishedDateLabel.text = "Publié \(bird.createdAt.toStringWithRelativeTime(strings: relativeTimeDict))"
        let departureDate = FrenchDateFormatter.formatDate(bird.departureDate)
        birdDateLabel.text = "Départ: \(departureDate)"
        birderProfilePic.sd_setImage(with: bird.birderProfilePicUrl, completed: nil)
        totalWeightLabel.text =  "\(bird.birdWeight) Kg"
        totalPriceLabel.text = "\(bird.birdTotalPrice)\(bird.currency)"
        pricePerKiloLabel.text = "\(bird.birdPricePerKilo)\(bird.currency)"
        
        
        let weightDesiredPrice = weightValue * bird.birdPricePerKilo
        weightDesiredPriceLabel.text = "\(weightDesiredPrice) \(bird.currency)"
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        switch destination {
            
        case is UINavigationController:
            let navigationController = destination as! UINavigationController
            if let ouiChatViewController = navigationController.viewControllers.first as? OuiChatViewController {
                ouiChatViewController.destinataireName = bird.birdTravelerName
                ouiChatViewController.destinataireId = bird.creator
                ouiChatViewController.destinataireUrl = bird.birderProfilePicUrl
            }
            
            if let birderProfileViewController = navigationController.viewControllers.first as? BirderProfileViewController {
                
                if let birder = birder {
                    birderProfileViewController.birder = birder
                }
                else {
                    FirebaseManager.shared.user(with: bird.creator, success: { (birder) in
                        birderProfileViewController.birder = birder
                    }) { (error) in
                        print(error?.localizedDescription ?? "Error getting birder")
                    }
                }    
            }
            
        default:
            print("Unknown")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterNotifications()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
    }
    
    @IBAction func takeAllWeightChanged(_ sender: UISegmentedControl) {
        let value  = sender.selectedSegmentIndex
        var weightDesiredPrice = weightValue * bird.birdPricePerKilo
        if value == 0 {
            weightDesiredStackView.isHidden = false
             weightDesiredPriceLabel.text = "\(weightDesiredPrice) \(bird.currency)"
        }
        else {
            weightDesiredStackView.isHidden = true
            weightDesiredPrice = bird.birdTotalPrice
            weightDesiredPriceLabel.text = "\(weightDesiredPrice) \(bird.currency)"
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let step:Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        weightValue = Int(roundedValue)
        let weightDesiredPrice = weightValue * bird.birdPricePerKilo
        weightDesiredLabel.text = "\(weightValue) Kg"
        weightDesiredPriceLabel.text = "\(weightDesiredPrice) \(bird.currency)"
    }
    
    
    @IBAction func createRequestAction(_ sender: UIButton) {
        
        if let quester = Datas.shared.birder {
            handleCreateRequestAction(for: quester)
        }
        else {
            FirebaseManager.shared.currentBirder(success: { (quester) in
                self.handleCreateRequestAction(for: quester)
            }) { (error) in
                SCLAlertView().showError("Error", subTitle: "User not logged in")
            }
        }
    }
    
    func handleCreateRequestAction(for quester: Birder) {
        let details = detailsTextView.text ?? ""
        let birderId = bird.creator
        let birderName = bird.birdTravelerName
        let birderProfilePicUrl = bird.birderProfilePicUrl
        let questerName = quester.displayName ?? ""
        let questerProfilePicUrl = quester.photoURL ?? URL(string: "defaultPic")!
        let departureCity = bird.departureCity
        let departureCountry = bird.departureCountry
        let departureDate = bird.departureDate
        let arrivalCity = bird.arrivalCity
        let arrivalCountry = bird.arrivalCountry
        let arrivalDate = bird.arrivalDate
        let creator = quester.identifier
        
        let request = Request(bird: bird.identifier, weight: weightValue, details: details, birderId: birderId  , birderName: birderName, birderProfilePicUrl: birderProfilePicUrl, questerName: questerName, questerProfilePicUrl: questerProfilePicUrl, departureCity: departureCity, departureCountry: departureCountry, departureDate: departureDate, arrivalCity: arrivalCity, arrivalCountry: arrivalCountry, arrivalDate: arrivalDate, creator: creator)
        
        activityIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.createRequest(request)
        })
    }
    
    @IBAction func segmentedControlChangedValue(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            weightValue = Int(weightSlider.value)
        }
        else {
            weightValue = bird.birdWeight
        }
        
        print(weightValue)
    }
    
    
    func createRequest(_ request: Request) {
        FirebaseManager.shared.createRequest(request, success: {
            print("Request Sent successfully")
            self.handleRequestCreationSucceed()
        }) { (error) in
            print(error ?? "Error creating request")
            self.activityIndicatorView.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func handleRequestCreationSucceed() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Fermer", backgroundColor: UIColor.Blue.ouiSendBlueColor, textColor: .white) {
            self.navigationController?.popViewController(animated: true)
        }
        alertView.showInfo("Félicitations", subTitle: "Votre Demande a été envoyée avec succès")
        activityIndicatorView.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    
}

extension BirdViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == "Précisez le contenu de votre colis")
        {
            textView.text = ""
            textView.textColor = UIColor.Blue.ouiSendBlueColor
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = "Précisez le contenu de votre colis"
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}
