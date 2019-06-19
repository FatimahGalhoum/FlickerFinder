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

protocol GroupsDataDelegate {
    func updateUI(data: [Group])
}

class GroupsPresenter{
    
    var flickrGroupsCoreData = [Group]()
    var delegate : GroupsDataDelegate!

    
    func fetchGroupData(searchText:String, handler: @escaping (_ status: Bool) -> ()){
        Alamofire.request(groupsURL(apiKey: apiKey, textTosearchFor: searchText, page: 1, numberOfPhotos: 100)).responseJSON { (response) in
            
            if response.result.isSuccess {
                var data = Data()
                data = response.data!
                let decoder = JSONDecoder()
                let flickrGroups = try? decoder.decode(FlickrGroupsResult.self, from: data)
                
                
                for item in 0...(flickrGroups?.groups!.group.count)! - 1{
                    let groupURL = "https://farm\((flickrGroups?.groups?.group[item].iconfarm)!).staticflickr.com/\((flickrGroups?.groups?.group[item].iconserver)!)/buddyicons/\((flickrGroups?.groups?.group[item].nsid)!)_m.jpg"
                    let iconID = flickrGroups?.groups?.group[item].nsid
                    let members = flickrGroups?.groups?.group[item].members
                    let photos = flickrGroups?.groups?.group[item].pool_count
                    let name = flickrGroups?.groups?.group[item].name
                    let topics = flickrGroups?.groups?.group[item].topic_count

                    let flickerGroup = Group(context: PresistenceService.context)
                    flickerGroup.id = iconID
                    flickerGroup.members = members
                    flickerGroup.topics = topics!
                    flickerGroup.name = name
                    flickerGroup.photos = photos
                    flickerGroup.iconURL = groupURL
                    flickerGroup.url = URL(string: flickerGroup.iconURL!)
                    PresistenceService.saveContext()
                    
                    self.flickrGroupsCoreData.append(flickerGroup)
                    self.delegate.updateUI(data: self.flickrGroupsCoreData)
                    //print(self.flickrPhotoCoreData[item].id)
                    //print(self.flickrPhotoCoreData[item].imageURL)
                }
                handler(true)
                
            } else {
                print("Can not get the data")
            }
        }
    }
    
    
}
