//
//  PersistanceService.swift
//  LikeApp
//
//  Created by Sukumar Anup Sukumaran on 05/04/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import Foundation
import CoreData

class PersistanceService {
    
    private init() {}
    
    //coredata
    
    static var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "LikeApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
   static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    //calling context of type NSManagedObjectContext to get access to the content in the class by calling the "fetchRequest" .
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
}
