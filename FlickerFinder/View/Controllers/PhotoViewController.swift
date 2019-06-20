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
import os


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
        os_log("refreshData function called inside PhotoViewController to retreive last search", log: Log.featchedCoreData, type: .info)
    }


    //MARK: - Photos search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text
        if keyword?.isEmpty == false {
        photoPresenter.fetchPhotoData(searchText: keyword!, handler: {(finished) in
            if finished {
                os_log("FetchPhotoData is called to get data from API", log: Log.networking, type: .info)
                self.refreshData()
                os_log("refreshData function after retrive data from API", log: Log.featchedCoreData, type: .info)
                //print("well done")
            }
        })
        } else {
            os_log("search bar is empty", log: Log.catchError, type: .error)
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
        } catch {
            os_log("Can't fetch core data", log: Log.catchError, type: .error)
        }
    }
    
    
    
    //MARK: - Delegates functions
    func noData(bool: Bool) {
        if bool{
            let alert = UIAlertController(title: "No Photos", message: "No photos to show", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            os_log("Function noData called. No data to show", log: Log.alertControllerCalled, type: .info)

        }
    }
    
    func internetConnection(bool: Bool) {
        if bool{
            os_log("Function noData called. Intrenet connection issue", log: Log.alertControllerCalled, type: .info)
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
        
//        KingfisherManager.shared.retrieveImage(with: photo.url!, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
//            cell.flickrPhoto.image = image
//
//        })
        
//        if let data =  photo.image as Data?{
//            cell.flickrPhoto.image = UIImage(data: data)
//        }
        cell.flickrPhoto.kf.indicatorType = .activity
        cell.flickrPhoto.kf.setImage(with: photo.url)
        
        cell.titleOfPhotoLabel.text = photo.title
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! ShowPhotoViewController
                let photo = featchedRCPhotos.object(at: indexPath)
                destinationController.url = photo.url
            }
        }
    }
    
}

