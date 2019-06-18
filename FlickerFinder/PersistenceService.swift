//
//  PersistenceService.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/18/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import Foundation
import CoreData


class PresistenceService{
    
    
    private init() {}
    
    static var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Flickr")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    

    static func deleteAllData(_ entity: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                persistentContainer.viewContext.delete(objectData)
            }
        } catch let error {
            print("Delete all data in \(Photo.self) error:", error)
        }
        
        
    }
    
}
