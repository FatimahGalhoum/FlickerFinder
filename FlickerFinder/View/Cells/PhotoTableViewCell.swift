//
//  PhotoTableViewCell.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/18/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var flickrPhoto: UIImageView!
    @IBOutlet weak var titleOfPhotoLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
            containerView.layer.cornerRadius = 6
            containerView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
