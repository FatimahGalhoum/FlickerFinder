//
//  PhotosJSONData.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/18/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import Foundation

struct FlickrResult: Codable {
    let photos: PhotosInfo?
    let stat: String
}


struct PhotosInfo: Codable {
    let page: Int
    let perpage: Int
    let pages: Int
    let photo: [PhotoURL]
}


struct PhotoURL : Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
}
