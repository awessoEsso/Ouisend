//
//  MyBirdCollectionViewCell.swift
//  Ouisend
//
//  Created by Esso Awesso on 02/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

protocol MyBirdCollectionViewCellDelegate {
    func showDetails()
}

class MyBirdCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var birderProfilePic: UIImageView!
    @IBOutlet weak var travelDescriptionLabel: UILabel!
    @IBOutlet weak var travelDateLabel: UILabel!
    @IBOutlet weak var birdWeightLabel: UILabel!
    @IBOutlet weak var requestNumberLabel: UILabel!
    
    
    var delegate: MyBirdCollectionViewCellDelegate?
    
    
    
    @IBAction func showBirdDetailsAction(_ sender: UIButton) {
        delegate?.showDetails()
    }
    
    
}
