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
            let group = try PresistenceService.context.fetch(fetchRequest)
            dataArray = group
            tableView.reloadData()
        } catch {}
        
    }

    //MARK: - Groups search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text
        if keyword?.isEmpty == false {
        groupPresenter.fetchGroupData(searchText: keyword!, handler: {(finished) in
            if finished {
                let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
                do {
                    let group = try PresistenceService.context.fetch(fetchRequest)
                    self.dataArray = group
                    self.tableView.reloadData()
                } catch {}
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
    
    //MARK:- Groups delegte functions
    func updateUI(data: [Group]) {
        dataArray = data
        tableView.reloadData()
    }
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
