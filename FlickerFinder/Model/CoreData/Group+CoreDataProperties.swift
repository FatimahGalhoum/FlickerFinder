//
//  Group+CoreDataProperties.swift
//  
//
//  Created by Fatimah Galhoum on 6/19/19.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var members: String?
    @NSManaged public var photos: String?
    @NSManaged public var topics: Int32
    @NSManaged public var iconURL: String?
    @NSManaged public var url: URL?

}
