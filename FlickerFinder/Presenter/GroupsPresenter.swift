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
                    
                    self.flickrGroupsCoreData.append(flickerGroup)

                }
                } else {
                    self.delegate.noData(bool: true)
                    print("nil")
                }

                handler(true)
                
            } else {
                self.delegate.internetConnection(bool: true)
                print("Can not get the data")
            }
        }
    }
    
    
}
