//
//  PhotoPresenter.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/18/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import Foundation
import Alamofire

protocol PhotoDataDelegate {
    func updateUI(data: [Photo])
}

class PhotoPresenter{
    
    var flickrPhotoCoreData = [Photo]()
    var delegate : PhotoDataDelegate!
    
    let apiKey = "1f128ae8f61db46906d7cad293fd3e23"
    
    func photoURL(apiKey key:String,textTosearchFor text: String,page: Int, numberOfPhotos number : Int) -> String {
        let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(text)&per_page=\(number)&page=&format=json&nojsoncallback=1"
        return url
    }
    
    
    func getURLdata(searchText:String, handler: @escaping (_ status: Bool) -> ()){
        Alamofire.request(photoURL(apiKey: apiKey, textTosearchFor: searchText, page: 1, numberOfPhotos: 100)).responseJSON { (response) in
            if response.result.isSuccess {
                var data = Data()
                data = response.data!
                let decoder = JSONDecoder()
                let flickrPhotos = try? decoder.decode(FlickrResult.self, from: data)
                
                PresistenceService.deleteAllData("Photo")
                
                for item in 0...(flickrPhotos?.photos!.photo.count)! - 1 {
                    let photoURL = "https://farm\((flickrPhotos?.photos?.photo[item].farm)!).staticflickr.com/\((flickrPhotos?.photos?.photo[item].server)!)/\((flickrPhotos?.photos?.photo[item].id)!)_\((flickrPhotos?.photos?.photo[item].secret)!)_m.jpg"
                    let photoID = flickrPhotos?.photos?.photo[item].id
                    let title = flickrPhotos?.photos?.photo[item].title
                    
                    let flickrPhoto = Photo(context: PresistenceService.context)
                    flickrPhoto.id = photoID
                    flickrPhoto.title = title
                    flickrPhoto.imageURL = photoURL
                    flickrPhoto.url = URL(string: flickrPhoto.imageURL!)
                    PresistenceService.saveContext()
                    self.flickrPhotoCoreData.append(flickrPhoto)
                    self.delegate.updateUI(data: self.flickrPhotoCoreData)
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
