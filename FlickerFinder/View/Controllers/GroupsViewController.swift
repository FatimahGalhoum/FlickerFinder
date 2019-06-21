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
import os

class GroupsViewController: UITableViewController, UISearchBarDelegate, GroupsDataDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var groupPresenter : GroupsPresenter!
    var refresher: UIRefreshControl!
    var featchedRCGroups: NSFetchedResultsController<Group>!
    
    var currentPage = 1
    var shouldShowLoadingCell = false
    var keyword = ""
    var numberOfPages: Int!
    var nodataBool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        groupPresenter = GroupsPresenter()
        groupPresenter.delegate = self
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refreshGroups), for: .valueChanged)
        refresher.beginRefreshing()
        
        refreshData()
        os_log("refreshData function called inside GroupsViewController to retreive last search", log: Log.featchedCoreData, type: .info)
    }

    //MARK: - Groups search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keyword = searchBar.text ?? ""
        if keyword.isEmpty == false {
            groupPresenter.fetchGroupData(currentPage: currentPage, searchText: encodingString(keyword: keyword), handler: {(finished) in
            os_log("fetchGroupData function takes search text as parameter", log: Log.parameters, type: .debug)
            if finished {
                PresistenceService.deleteAllData("Group")
                os_log("Function deleteAllData called to delete photo data from core data", log: Log.updateCoreData, type: .info)
                self.pagedResponse()
            }
                self.nodataBool = false
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
    func refreshGroups() {
        currentPage = 1
        groupPresenter.fetchGroupData(refresh: true, currentPage: currentPage, searchText: encodingString(keyword: keyword), handler: {(finished) in
            self.pagedResponse()
            print("refresh Photos")
        })
    }
    func fetchNextPage() {
        currentPage += 1
        groupPresenter.fetchGroupData(currentPage: currentPage, searchText: encodingString(keyword: keyword), handler: {(finished) in
            self.pagedResponse()
        })
    }
    
    func pagedResponse(){
        if nodataBool == false{
        self.shouldShowLoadingCell = self.currentPage < self.numberOfPages
        self.refresher.endRefreshing()
        os_log("FetchGroupData is called to get data from API", log: Log.networking, type: .info)
        self.refreshData()
        os_log("refreshData function after retrive data from API", log: Log.featchedCoreData, type: .info)
        }
    }
    
    //MARK: - Refresh core data
    func refreshData(){
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        do {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "row", ascending: true)]
            self.featchedRCGroups = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PresistenceService.context, sectionNameKeyPath: nil, cacheName: nil)
            try self.featchedRCGroups.performFetch()
            self.tableView.reloadData()
        } catch {
            os_log("Can't fetch core data", log: Log.catchError, type: .error)
        }
    }
    
    //MARK:- Groups delegte functions
    func noData(bool: Bool) {
        if bool{
            nodataBool = true
            os_log("Function noData called. No data to show", log: Log.alertControllerCalled, type: .info)
            let alert = UIAlertController(title: "No Groups", message: "There is no groups under this Name.\nTry Again", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
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
    


    // MARK: - Groups TabeleView data

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let group = featchedRCGroups.fetchedObjects else { return 0 }
        return shouldShowLoadingCell ? group.count + 1 : group.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoadingIndexPath(indexPath) {
            return LoadingCell(style: .default, reuseIdentifier: "loading")
        } else {
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
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLoadingIndexPath(indexPath) else { return }
        fetchNextPage()
        os_log("fetchNextPage is called", log: Log.pagination, type: .info)

    }
    
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else { return false }
        let group = featchedRCGroups.fetchedObjects
        return indexPath.row == group?.count
    }
}
