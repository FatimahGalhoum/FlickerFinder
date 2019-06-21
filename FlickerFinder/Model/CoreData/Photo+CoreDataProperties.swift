//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Fatimah Galhoum on 6/21/19.
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
    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var row: Int32

}
