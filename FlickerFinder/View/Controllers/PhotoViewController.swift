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
    var dataArray = [Photo]()
    
    var featchedRC: NSFetchedResultsController<Photo>!

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
//                let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
//                do {
//                    let photo = try PresistenceService.context.fetch(fetchRequest)
//                    self.dataArray = photo
//                    self.tableView.reloadData()
//                } catch {}
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
    
    func refreshData(){
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        do {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
            self.featchedRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PresistenceService.context, sectionNameKeyPath: nil, cacheName: nil)
            try self.featchedRC.performFetch()
            self.tableView.reloadData()
        } catch {}
    }
    
    
    //MARK: - Photos delegate functions
    
//    func updateUI(data: [Photo]){
//        dataArray = data
//        tableView.reloadData()
//    }
    
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
        guard let photo = featchedRC.fetchedObjects else { return 0 }
        return photo.count
        //return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flickrPhotoCell", for: indexPath) as! PhotoTableViewCell
        cell.flickrPhoto.kf.indicatorType = .activity
        
         let photo = featchedRC.object(at: indexPath)
        
        cell.flickrPhoto.kf.setImage(with: photo.url)
        cell.titleOfPhotoLabel.text = photo.title
        //cell.flickrPhoto.kf.setImage(with: dataArray[indexPath.row].url)
        //cell.titleOfPhotoLabel.text = dataArray[indexPath.row].title
        return cell
    }
    
}

