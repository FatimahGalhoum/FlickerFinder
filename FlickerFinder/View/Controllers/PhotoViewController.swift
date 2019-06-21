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
    var refresher: UIRefreshControl!
    var featchedRCPhotos: NSFetchedResultsController<Photo>!

    var currentPage = 1
    var shouldShowLoadingCell = false
    var keyword = ""
    var numberOfPages: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPresenter = PhotoPresenter()
        photoPresenter.delegate = self
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refreshPhotos), for: .valueChanged)
        refresher.beginRefreshing()
        
        refreshData()
        os_log("refreshData function called inside PhotoViewController to retreive last search", log: Log.featchedCoreData, type: .info)
    }


    //MARK: - Photos search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keyword = searchBar.text ?? ""
        
        if keyword.isEmpty == false {
            photoPresenter.fetchPhotoData(currentPage: currentPage, searchText: encodingString(keyword: keyword), handler: {(finished) in
            os_log("fetchPhotoData function takes search text as parameter", log: Log.parameters, type: .debug)
            if finished {
                PresistenceService.deleteAllData("Photo")
                os_log("Function deleteAllData called to delete photo data from core data", log: Log.updateCoreData, type: .info)
                
                self.pagedResponse()
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
    
    
    //MARK: - Pagination
    @objc
    func refreshPhotos() {
        currentPage = 1
        photoPresenter.fetchPhotoData(refresh: true, currentPage: currentPage, searchText: encodingString(keyword: keyword), handler: {(finished) in
            self.pagedResponse()
            print("refresh Photos")
        })
    }
    func fetchNextPage() {
        currentPage += 1
        photoPresenter.fetchPhotoData(currentPage: currentPage, searchText: encodingString(keyword: keyword), handler: {(finished) in
            self.pagedResponse()
        })
    }
    
    func pagedResponse(){
        self.shouldShowLoadingCell = self.currentPage < self.numberOfPages
        self.refresher.endRefreshing()
        os_log("FetchPhotoData is called to get data from API", log: Log.networking, type: .info)
        self.refreshData()
        os_log("refreshData function after retrive data from API", log: Log.featchedCoreData, type: .info)
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
    
    func numberOfPages(num: Int) {
        numberOfPages = num
    }
    
    
    //MARK: - Photos TableView Data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let photo = featchedRCPhotos.fetchedObjects else { return 0 }
        return shouldShowLoadingCell ? photo.count + 1 : photo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoadingIndexPath(indexPath) {
            return LoadingCell(style: .default, reuseIdentifier: "loading")
        } else {
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
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLoadingIndexPath(indexPath) else { return }
        fetchNextPage()
    }
    
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else { return false }
        let photo = featchedRCPhotos.fetchedObjects
        return indexPath.row == photo?.count
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

