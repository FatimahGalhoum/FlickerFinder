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
    func noData(bool: Bool)
    func internetConnection(bool: Bool)
    func numberOfPages(num: Int)
}



//MARK: - Group Presenter
class GroupsPresenter{
    
    var flickrGroupsCoreData = [Group]()
    var delegate : GroupsDataDelegate!

    
    
    //MARK: - Groups featch data
    func fetchGroupData(refresh: Bool = false, currentPage: Int, searchText:String, handler: @escaping (_ status: Bool) -> ()){
        
        Alamofire.request(groupsURL(apiKey: apiKey, textTosearchFor: searchText, page: currentPage, numberOfPhotos: 10)).responseJSON { (response) in
            
            if response.result.isSuccess {
                var data = Data()
                data = response.data!
                let decoder = JSONDecoder()
                let flickrGroups = try? decoder.decode(FlickrGroupsResult.self, from: data)
                
                print("\n\n\n\n\n\n\(groupsURL(apiKey: apiKey, textTosearchFor: searchText, page: currentPage, numberOfPhotos: 10))")
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
                    
                    let numberOfPages = flickrGroups?.groups?.pages
                    self.delegate.numberOfPages(num: numberOfPages!)
                    
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
