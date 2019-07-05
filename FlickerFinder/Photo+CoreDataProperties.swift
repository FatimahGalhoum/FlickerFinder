//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Fatimah Galhoum on 7/2/19.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: NSData?
    @NSManaged public var imageURL: String?
    @NSManaged public var row: Int32
    @NSManaged public var title: String?
    @NSManaged public var url: URL?

}
