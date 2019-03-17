//
//  AcceptedRequestCollectionViewCell.swift
//  Ouisend
//
//  Created by Esso Awesso on 10/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

protocol AcceptedRequestCollectionViewCellDelegate {
    func writeToBirder(cell: AcceptedRequestCollectionViewCell)
}

class AcceptedRequestCollectionViewCell: UICollectionViewCell {
    
    var delegate: AcceptedRequestCollectionViewCellDelegate?
    
    @IBOutlet weak var travelDescriptionLabel: UILabel!
    
    @IBOutlet weak var birderProfilePicImageView: UIImageView!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var departureDateLabel: UILabel!
    
    @IBOutlet weak var birdStatusImageView: UIImageView!
    
    @IBOutlet weak var birdStatusDescriptionLabel: UILabel!
    
    @IBAction func writeToBirderAction(_ sender: UIButton) {
        delegate?.writeToBirder(cell: self)
    }
    
    
}
