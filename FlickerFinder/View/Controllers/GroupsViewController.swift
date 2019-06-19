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
    var dataArray = [Group]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupPresenter = GroupsPresenter()
        groupPresenter.delegate = self
        
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        do {
            let photo = try PresistenceService.context.fetch(fetchRequest)
            dataArray = photo
            tableView.reloadData()
        } catch {}
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text
        groupPresenter.fetchGroupData(searchText: keyword!, handler: {(finished) in
            if finished {
                self.tableView.reloadData()
            }
        })
        self.view.endEditing(true)
    }
    
    
    func updateUI(data: [Group]) {
        dataArray = data
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flickrGroupsCell", for: indexPath) as! GroupsTableViewCell

        cell.iconImage.kf.indicatorType = .activity
        cell.iconImage.kf.setImage(with: dataArray[indexPath.row].url)
        cell.groupNameLabel.text = dataArray[indexPath.row].name
        cell.discussionLabel.text = dataArray[indexPath.row].topics
        cell.membersLabel.text = dataArray[indexPath.row].members
        cell.photosLabel.text = dataArray[indexPath.row].photos
 
        return cell
    }
}
