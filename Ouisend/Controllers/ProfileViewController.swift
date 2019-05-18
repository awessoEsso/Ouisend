//
//  ProfileViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 06/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var birderNameLabel: UILabel!
    
    @IBOutlet weak var birderEmailLabel: UILabel!
    
    @IBOutlet weak var birdsNumberLabel: UILabel!
    
    @IBOutlet weak var requestsNumberLabel: UILabel!
    
    @IBOutlet weak var birderProfilePicImageView: UIImageView!
    
    @IBOutlet weak var alertsNumberLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let birderData = defaults.object(forKey: "birder") as? Data,
            let birder = NSKeyedUnarchiver.unarchiveObject(with: birderData) as? Birder {
            setupDatasWithBirder(birder)
        }
        else {
            if let currentUser = Auth.auth().currentUser {
                FirebaseManager.shared.user(with: currentUser.uid, success: { (birder) in
                    self.setupDatasWithBirder(birder)
                }) { (error) in
                    print(error?.localizedDescription ?? "")
                }
            }
        }
        
    }
    
    func setupDatasWithBirder(_ birder: Birder) {
        birderNameLabel.text = birder.displayName
        birderEmailLabel.text = birder.email
        birderProfilePicImageView.sd_setImage(with: birder.photoURL, completed: nil)
        
        FirebaseManager.shared.userJoins(success: { (results) in
            self.birdsNumberLabel.text = "\(results["birds"] ?? 0 )"
            self.requestsNumberLabel.text = "\(results["requests"] ?? 0 )"
            self.alertsNumberLabel.text = "\(results["topics"] ?? 0 )"
        }) { (error) in
            print(error?.localizedDescription ?? "Error getting user Joins")
        }
        
    }
    
    
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
