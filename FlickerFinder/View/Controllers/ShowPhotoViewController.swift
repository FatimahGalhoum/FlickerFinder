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

        // Do any additional setup after loading the view.
        photo.kf.setImage(with: url)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        textView.text = text
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
