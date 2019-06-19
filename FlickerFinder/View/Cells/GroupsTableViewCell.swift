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
    
    let cornerRadius : CGFloat = 25.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
//            containrView.layer.cornerRadius = 10
//            containrView.layer.masksToBounds = true
        
        
        containrView.layer.cornerRadius = cornerRadius
        containrView.layer.shadowColor = UIColor.gray.cgColor
        containrView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        containrView.layer.shadowRadius = 3.0
        containrView.layer.shadowOpacity = 0.9
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
