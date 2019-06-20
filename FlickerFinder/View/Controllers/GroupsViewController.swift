//
//  GroupsViewController.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/18/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

class GroupsViewController: UITableViewController, UISearchBarDelegate, GroupsDataDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var groupPresenter : GroupsPresenter!
    var featchedRCGroups: NSFetchedResultsController<Group>!
    //var dataArray = [Group]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        groupPresenter = GroupsPresenter()
        groupPresenter.delegate = self
        
        refreshData()
    }

    //MARK: - Groups search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text
        if keyword?.isEmpty == false {
        groupPresenter.fetchGroupData(searchText: keyword!, handler: {(finished) in
            if finished {
                self.refreshData()
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
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        do {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
            self.featchedRCGroups = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PresistenceService.context, sectionNameKeyPath: nil, cacheName: nil)
            try self.featchedRCGroups.performFetch()
            self.tableView.reloadData()
        } catch {}
    }
    
    //MARK:- Groups delegte functions
    func noData(bool: Bool) {
        if bool{
            let alert = UIAlertController(title: "No Groups", message: "There is no groups under this Name.\nTry Again", preferredStyle: .alert)
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
    
    


    // MARK: - Groups TabeleView data

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let group = featchedRCGroups.fetchedObjects else { return 0 }
        return group.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flickrGroupsCell", for: indexPath) as! GroupsTableViewCell

        let group = featchedRCGroups.object(at: indexPath)

        cell.iconImage.kf.indicatorType = .activity
        cell.iconImage.kf.setImage(with: group.url)
        cell.groupNameLabel.text = group.name
        cell.discussionLabel.text = group.topics
        cell.membersLabel.text = group.members
        cell.photosLabel.text = group.photos
 
        return cell
    }
}
