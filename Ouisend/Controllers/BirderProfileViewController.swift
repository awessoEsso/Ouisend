//
//  BirderProfileViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 23/05/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import Firebase

class BirderProfileViewController: UITableViewController {
    
    @IBOutlet weak var birderNameLabel: UILabel!
    
    @IBOutlet weak var birderEmailLabel: UILabel!
    
    @IBOutlet weak var birdsNumberLabel: UILabel!
    
    @IBOutlet weak var requestsNumberLabel: UILabel!
    
    @IBOutlet weak var birderProfilePicImageView: UIImageView!
    
    var birder: Birder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let birder = birder {
            setupDatasWithBirder(birder)
        }
    }
    
    func setupDatasWithBirder(_ birder: Birder) {
        birderNameLabel.text = birder.displayName
        birderEmailLabel.text = birder.email
        birderProfilePicImageView.sd_setImage(with: birder.photoURL, completed: nil)
        
        FirebaseManager.shared.userJoins(success: { (results) in
            self.birdsNumberLabel.text = "\(results["birds"] ?? 0 )"
            self.requestsNumberLabel.text = "\(results["requests"] ?? 0 )"
        }) { (error) in
            print(error?.localizedDescription ?? "Error getting user Joins")
        }
        
    }
    
    
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
