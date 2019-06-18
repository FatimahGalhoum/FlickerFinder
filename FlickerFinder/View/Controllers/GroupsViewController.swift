//
//  GroupsViewController.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/18/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import UIKit

class GroupsViewController: UITableViewController, UISearchBarDelegate, GroupsDataDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var groupPresenter : GroupsPresenter!
    var dataArray = [Group]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupPresenter = GroupsPresenter()
        groupPresenter.delegate = self
        
//        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
//        do {
//            let photo = try PresistenceService.context.fetch(fetchRequest)
//            groupPresenter.flickrPhotoCoreData = photo
//            tableView.reloadData()
//        } catch {}
        
    }

    
    
    func updateUI(data: [Group]) {
        tableView.reloadData()
    }
    
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flickrGroupsCell", for: indexPath) as! GroupsTableViewCell

        cell.iconImage.image = UIImage(named: "coco")
        cell.groupNameLabel.text = "fdfgd"
        
        return cell
    }
    


}
