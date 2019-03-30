//
//  DiscussionTableViewCell.swift
//  Ouisend
//
//  Created by Esso Awesso on 30/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class DiscussionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var participantImageView: UIImageView!
    @IBOutlet weak var participantNameLabel: UILabel!
    @IBOutlet weak var channelLastMessageLabel: UILabel!
    @IBOutlet weak var unreadCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
