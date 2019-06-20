//
//  ViewController.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/18/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData
class PhotoViewController: UITableViewController, UISearchBarDelegate, PhotoDataDelegate {

  
    @IBOutlet weak var searchBar: UISearchBar!
    
    var photoPresenter : PhotoPresenter!
    var featchedRCPhotos: NSFetchedResultsController<Photo>!

    //var dataArray = [Photo]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        photoPresenter = PhotoPresenter()
        photoPresenter.delegate = self
        
        refreshData()
    }


    //MARK: - Photos search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text
        if keyword?.isEmpty == false {
        photoPresenter.fetchPhotoData(searchText: keyword!, handler: {(finished) in
            if finished {
                self.refreshData()
                print("well done")
            }
        })
        } else {
            let alert = UIAlertController(title: "Enter text", message: "Enter text to search for", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        self.view.endEditing(true)
    }
    
    
    
    //MARK: - Refresh core data
    func refreshData(){
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        do {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
            self.featchedRCPhotos = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PresistenceService.context, sectionNameKeyPath: nil, cacheName: nil)
            try self.featchedRCPhotos.performFetch()
            self.tableView.reloadData()
        } catch {}
    }
    
    
    
    //MARK: - Delegates functions
    func noData(bool: Bool) {
        if bool{
            let alert = UIAlertController(title: "No Photos", message: "No photos to show", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func internetConnection(bool: Bool) {
        if bool{
            let alert = UIAlertController(title: "Ooops!", message: "There is no internet connection\nTry Again", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    //MARK: - Photos TableView Data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let photo = featchedRCPhotos.fetchedObjects else { return 0 }
        return photo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flickrPhotoCell", for: indexPath) as! PhotoTableViewCell
        
        let photo = featchedRCPhotos.object(at: indexPath)
        cell.flickrPhoto.kf.indicatorType = .activity
        cell.flickrPhoto.kf.setImage(with: photo.url)
        cell.titleOfPhotoLabel.text = photo.title
        return cell
    }
    
}

