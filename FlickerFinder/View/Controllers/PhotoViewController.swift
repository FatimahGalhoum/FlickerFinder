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

    override func viewDidLoad() {
        super.viewDidLoad()
        photoPresenter = PhotoPresenter()
        photoPresenter.delegate = self
        
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        do {
            let photo = try PresistenceService.context.fetch(fetchRequest)
            dataArray = photo
            tableView.reloadData()
        } catch {}
    }


    //MARK: - Photos search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text
        photoPresenter.fetchPhotoData(searchText: keyword!, handler: {(finished) in
            if finished {
                self.tableView.reloadData()
                print("well done")
            }
        })
        self.view.endEditing(true)
    }
    
    
    //MARK: - Photos delegate functions
    func updateUI(data: [Photo]){
        dataArray = data
        tableView.reloadData()
    }
    
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
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flickrPhotoCell", for: indexPath) as! PhotoTableViewCell
        
        cell.flickrPhoto.kf.indicatorType = .activity
        cell.flickrPhoto.kf.setImage(with: dataArray[indexPath.row].url)
        cell.titleOfPhotoLabel.text = dataArray[indexPath.row].title
        return cell
    }
    
}

