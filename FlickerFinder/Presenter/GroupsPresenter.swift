//
//  GroupsPresenter.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/19/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
import os

//MARK: - Groups delegate
protocol GroupsDataDelegate {
    //func updateUI(data: [Group])
    func noData(bool: Bool)
    func internetConnection(bool: Bool)
}



//MARK: - Group Presenter
class GroupsPresenter{
    
    var flickrGroupsCoreData = [Group]()
    var delegate : GroupsDataDelegate!

    
    
    //MARK: - Groups featch data
    func fetchGroupData(searchText:String, handler: @escaping (_ status: Bool) -> ()){
        Alamofire.request(groupsURL(apiKey: apiKey, textTosearchFor: searchText, page: 1, numberOfPhotos: 100)).responseJSON { (response) in
            
            if response.result.isSuccess {
                var data = Data()
                data = response.data!
                let decoder = JSONDecoder()
                let flickrGroups = try? decoder.decode(FlickrGroupsResult.self, from: data)
                
                PresistenceService.deleteAllData("Group")
                os_log("Function deleteAllData called to delete group data from core data", log: Log.updateCoreData, type: .info)
                
                if flickrGroups?.groups?.group.isEmpty == false {
                for item in 0...(flickrGroups?.groups!.group.count)! - 1{
                    let groupURL = "https://farm\((flickrGroups?.groups?.group[item].iconfarm)!).staticflickr.com/\((flickrGroups?.groups?.group[item].iconserver)!)/buddyicons/\((flickrGroups?.groups?.group[item].nsid)!)_m.jpg"
                    let iconID = flickrGroups?.groups?.group[item].nsid
                    let members = flickrGroups?.groups?.group[item].members
                    let photos = flickrGroups?.groups?.group[item].pool_count
                    let name = flickrGroups?.groups?.group[item].name
                    let topics = flickrGroups?.groups?.group[item].topic_count

                    let membersInt = formatNumber(Int(members!)!)
                    let photosInt = formatNumber(Int(photos!)!)
                    let topicsInt = formatNumber(Int(topics!)!)
                    
                    let flickerGroup = Group(context: PresistenceService.context)
                    flickerGroup.id = iconID
                    flickerGroup.members = membersInt
                    flickerGroup.topics = topicsInt
                    flickerGroup.name = name
                    flickerGroup.photos = photosInt
                    flickerGroup.iconURL = groupURL
                    flickerGroup.url = URL(string: flickerGroup.iconURL!)
                    PresistenceService.saveContext()
                    //os_log("Function saveContext called to save group data in core data", log: Log.updateCoreData, type: .info)
                    self.flickrGroupsCoreData.append(flickerGroup)

                }
                } else {
                    self.delegate.noData(bool: true)
                    os_log("Data from API is empty", log: Log.catchError, type: .error)
                    print("nil")
                }

                handler(true)
                
            } else {
                self.delegate.internetConnection(bool: true)
                os_log("Internt connection issues", log: Log.catchError, type: .error)
                print("Can not get the data")
            }
        }
    }
    
    
}
