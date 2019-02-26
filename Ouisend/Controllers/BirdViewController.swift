//
//  BirdViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 26/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class BirdViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var weightDesiredStackView: UIStackView!
    
    @IBOutlet weak var weightDesiredLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        if value == 0 {
            weightDesiredStackView.isHidden = false
        }
        else {
            weightDesiredStackView.isHidden = true
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let step:Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        let weightValue = Int(roundedValue)
        weightDesiredLabel.text = "\(weightValue)Kg"
    }
    
}
