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
    
    
    
    let cornerRadius : CGFloat = 25.0

    override func awakeFromNib() {
        super.awakeFromNib()
//            containerView.layer.cornerRadius = 10
//            containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        containerView.layer.shadowRadius = 3.0
        containerView.layer.shadowOpacity = 0.9
        
    
        flickrPhoto.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        flickrPhoto.layer.cornerRadius = cornerRadius
        flickrPhoto.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
