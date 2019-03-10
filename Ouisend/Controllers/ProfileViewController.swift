//
//  ProfileViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 06/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var birderNameLabel: UILabel!
    
    @IBOutlet weak var birderEmailLabel: UILabel!
    
    @IBOutlet weak var birdsNumberLabel: UILabel!
    
    @IBOutlet weak var requestsNumberLabel: UILabel!
    
    @IBOutlet weak var birderProfilePicImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let birder = Datas.shared.birder else {
            
            
            return
            
        }
        
        birderNameLabel.text = birder.displayName
        birderEmailLabel.text = birder.email
        
        birderProfilePicImageView.sd_setImage(with: birder.photoURL, completed: nil)
        
    }
    


}