//
//  ShowPhotoViewController.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/20/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import UIKit
import CoreData

class ShowPhotoViewController: UIViewController {

    
    var featchedRCPhotos: NSFetchedResultsController<Photo>!

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    
    var url: URL!
    var text = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }

    func updateUI(){
        photo.kf.setImage(with: url)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        textView.text = text
    }
    
}
