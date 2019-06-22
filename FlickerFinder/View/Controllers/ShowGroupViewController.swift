//
//  ShowGroupViewController.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/22/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import UIKit

class ShowGroupViewController: UIViewController {

    
    @IBOutlet weak var groupPhoto: UIImageView!
    @IBOutlet weak var membersCountLabel: UILabel!
    @IBOutlet weak var photoCountLabel: UILabel!
    @IBOutlet weak var discussionCountLabel: UILabel!
    
    
    
    var memberCount = ""
    var photoCount = ""
    var discussionCount = ""
    var url: URL!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        groupPhoto.layer.cornerRadius = 25
        groupPhoto.clipsToBounds = true
    }
    

    func updateUI() {
        groupPhoto.kf.setImage(with: url, placeholder: UIImage(named: "no-image"), options: nil, progressBlock: nil, completionHandler: nil)
        membersCountLabel.text = memberCount
        photoCountLabel.text = photoCount
        discussionCountLabel.text = discussionCount
    }

}
