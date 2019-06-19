//
//  PhotoPresenter.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/18/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import Foundation
import Alamofire


//MARK: - Photos delegate
protocol PhotoDataDelegate {
    func updateUI(data: [Photo])
    func noData(bool: Bool)
    func internetConnection(bool: Bool)
}


//MARK: - Photo Presenter Class

class PhotoPresenter{
    
    var flickrPhotoCoreData = [Photo]()
    var delegate : PhotoDataDelegate!
    

    //MARK: - Photos featch function
    func fetchPhotoData(searchText:String, handler: @escaping (_ status: Bool) -> ()){
        Alamofire.request(photoURL(apiKey: apiKey, textTosearchFor: searchText, page: 1, numberOfPhotos: 100)).responseJSON { (response) in
            if response.result.isSuccess {
                var data = Data()
                data = response.data!
                let decoder = JSONDecoder()
                let flickrPhotos = try? decoder.decode(FlickrResult.self, from: data)
                
                PresistenceService.deleteAllData("Photo")
                
                if flickrPhotos?.photos?.photo.isEmpty == false{
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
