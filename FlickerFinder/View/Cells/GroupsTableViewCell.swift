//
//  GroupsTableViewCell.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/18/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import UIKit

class GroupsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var containrView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var photosLabel: UILabel!
    @IBOutlet weak var discussionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
            containrView.layer.cornerRadius = 6
            containrView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
