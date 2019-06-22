//
//  PhotoPresenter.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/18/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import Foundation
import Alamofire
import Kingfisher
import os


//MARK: - Photos delegate
protocol PhotoDataDelegate {
    func noData(bool: Bool)
    func internetConnection(bool: Bool)
    func numberOfPages(num: Int)
}


//MARK: - Photo Presenter Class

class PhotoPresenter{
    
    var flickrPhotoCoreData = [Photo]()
    var delegate : PhotoDataDelegate?
    
    var count = 1
    
    //MARK: - Photos featch function
    func fetchPhotoData(refresh: Bool = false, currentPage: Int, searchText:String, handler: @escaping (_ status: Bool) -> ()){
        
        Alamofire.request(photoURL(apiKey: apiKey, textTosearchFor: searchText, page: currentPage, numberOfPhotos: 30), method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                var data = Data()
                data = response.data!
                let decoder = JSONDecoder()
                let flickrPhotos = try? decoder.decode(FlickrResult.self, from: data)
                
                if flickrPhotos?.photos?.photo.isEmpty == false{
                    for item in 0...(flickrPhotos?.photos!.photo.count)! - 1 {
                        let photoURL = "https://farm\((flickrPhotos?.photos?.photo[item].farm)!).staticflickr.com/\((flickrPhotos?.photos?.photo[item].server)!)/\((flickrPhotos?.photos?.photo[item].id)!)_\((flickrPhotos?.photos?.photo[item].secret)!)_m.jpg"
                        let photoID = flickrPhotos?.photos?.photo[item].id
                        let title = flickrPhotos?.photos?.photo[item].title
                        
                        let numberOfPages = flickrPhotos?.photos?.pages
                        
                            if self.delegate != nil {
                                self.delegate?.numberOfPages(num: numberOfPages!)
                            }
                        
                        let flickrPhoto = Photo(context: PresistenceService.context)
                        flickrPhoto.id = photoID
                        flickrPhoto.title = title
                        flickrPhoto.imageURL = photoURL
                        flickrPhoto.url = URL(string: flickrPhoto.imageURL!)
                        flickrPhoto.row = Int32(self.count + 1)
                        
                        PresistenceService.saveContext()
                        self.flickrPhotoCoreData.append(flickrPhoto)
                    }
                } else {
                    if self.delegate != nil {
                        self.delegate?.noData(bool: true)
                    }
                    os_log("Data from API is empty", log: Log.catchError, type: .error)
                    print("nil")
                }
                handler(true)
                
            } else {
                if self.delegate != nil {
                    self.delegate?.internetConnection(bool: true)
                }
                //handler(false)
                os_log("Internt connection issues", log: Log.catchError, type: .error)
                
            }
        }
        
        if !NetworkState.isConnected(){
            handler(false)
        }
        
    }
    
    
}
