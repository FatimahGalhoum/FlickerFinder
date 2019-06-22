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

        groupPhoto.kf.setImage(with: url, placeholder: UIImage(named: "no-image"), options: nil, progressBlock: nil, completionHandler: nil)
        membersCountLabel.text = memberCount
        photoCountLabel.text = photoCount
        discussionCountLabel.text = discussionCount
   
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
