//
//  SimpleSearchViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 22/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class SimpleSearchViewController: UIViewController {
    
    
    @IBOutlet weak var badgeButtonItem: BadgeBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        badgeButtonItem.badgeNumber = 2
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
