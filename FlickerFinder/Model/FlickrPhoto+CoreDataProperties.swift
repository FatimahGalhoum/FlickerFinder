//
//  FlickrPhoto+CoreDataProperties.swift
//  
//
//  Created by Fatimah Galhoum on 6/18/19.
//
//

import Foundation
import CoreData


extension FlickrPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlickrPhoto> {
        return NSFetchRequest<FlickrPhoto>(entityName: "Photo")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: NSData?
    @NSManaged public var imageURL: String?
    @NSManaged public var url: URL?

}
