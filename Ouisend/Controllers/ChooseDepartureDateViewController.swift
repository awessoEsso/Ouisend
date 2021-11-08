//
//  ChooseDepartureDateViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 01/06/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class ChooseDepartureDateViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var departureCity: City?
    
    var destinationCity: City?
    
    var departureDate: Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let currentLocale = NSLocale.current
        
        datePicker.locale = currentLocale
        datePicker.minimumDate = Date()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        switch destination {
        case is ChoosePriceAndWeightViewController:
            let choosePriceAndWeightViewController = destination as! ChoosePriceAndWeightViewController
            choosePriceAndWeightViewController.departureCity = departureCity
            choosePriceAndWeightViewController.destinationCity = destinationCity
            choosePriceAndWeightViewController.departureDate = departureDate
            
        default:
            print("Unknown segue")
        }
    }
    
    @IBAction func dateValueChanged(_ sender: UIDatePicker) {
        nextButton.alpha = 1
        nextButton.isEnabled = true
        departureDate = sender.date
    }
    
    
    
    
    @IBAction func nextAction(_ sender: UIButton) {
        if let departureDate = departureDate {
            performSegue(withIdentifier: "showChoosePriceAndWeight", sender: nil)
        }
        
    }
    

}
