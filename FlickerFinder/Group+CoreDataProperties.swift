//
//  Group+CoreDataProperties.swift
//  
//
//  Created by Fatimah Galhoum on 7/2/19.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var iconURL: String?
    @NSManaged public var id: String?
    @NSManaged public var members: String?
    @NSManaged public var name: String?
    @NSManaged public var photos: String?
    @NSManaged public var row: Int32
    @NSManaged public var topics: String?
    @NSManaged public var url: URL?

}
