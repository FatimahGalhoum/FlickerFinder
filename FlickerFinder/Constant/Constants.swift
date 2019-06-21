//
//  Constants.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/19/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import Foundation



let apiKey = "1f128ae8f61db46906d7cad293fd3e23"

func photoURL(apiKey key:String,textTosearchFor text: String,page: Int, numberOfPhotos number : Int) -> String {
    let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(text)&per_page=\(number)&page=\(page)&format=json&nojsoncallback=1"
    return url
}
    

func groupsURL(apiKey key:String,textTosearchFor text: String,page: Int, numberOfPhotos number : Int) -> String {
    let url = "https://www.flickr.com/services/rest/?method=flickr.groups.search&api_key=\(apiKey)&text=\(text)&per_page=\(number)&page=\(page)&format=json&nojsoncallback=1"
    
    return url
}


func encodingString(keyword: String) -> String{
    guard let escapedString = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return "Nothing" }
    return escapedString
}
