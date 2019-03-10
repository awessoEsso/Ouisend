//
//  SearchViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 06/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FirebaseManager.shared.createTopicNotification("Hello, this is my first notification", topic: "Lome-Paris")
    }
    
    @IBAction func messagerie(_ sender: UIButton) {
        
        let url = URL(string: "https://m.me/1979723412333172")!
        UIApplication.init().open(url, options: [:], completionHandler: nil)
        
    }
    
    

}
