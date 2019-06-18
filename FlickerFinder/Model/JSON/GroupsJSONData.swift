//
//  GroupsJSONData.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/18/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import Foundation

struct FlickrGroupsResult: Codable {
    let groups: GroupsInfo?
    let stat: String
}


struct GroupsInfo: Codable {
    let page: Int
    let perpage: Int
    let pages: Int
    let group: [GroupURL]
}


struct GroupURL : Codable {
    let nsid: String
    let name: String
    let iconserver: String
    let iconfarm: Int
    let members: String
    let topic_count: Int32
    let pool_count: String
}
