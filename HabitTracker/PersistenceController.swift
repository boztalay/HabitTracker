//
//  PersistenceController.swift
//  HabitTracker
//
//  Created by Ben Oztalay on 4/9/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import CoreData

class PersistenceController: NSObject {
    
    var managedObjectContext: NSManagedObjectContext
    private var privateContext: NSManagedObjectContext
    
    init(completionCallback: (() -> ())?) {
        // Create the managed object model
        let modelUrl = NSBundle.mainBundle().URLForResource("HabitTracker", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelUrl)!
        
        // Create our private (write to disk) and main (for UI) contexts
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
        // Create and set the persistent store coordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        self.privateContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        super.init()
        
        // Set up the actual store, but do it in the background because it might take a while
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let persistentStoreCoordinator = self.privateContext.persistentStoreCoordinator
            var options = NSMutableDictionary()
            
            options[NSMigratePersistentStoresAutomaticallyOption] = true
            options[NSInferMappingModelAutomaticallyOption] = true
            options[NSSQLitePragmasOption] = ["journal_mode" : "DELETE"]
            
            let fileManager = NSFileManager.defaultManager()
            let documentsUrl = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last as! NSURL
            let storeUrl = documentsUrl.URLByAppendingPathComponent("DataModel.sqlite")
            
            if let completionCallback = completionCallback {
                dispatch_async(dispatch_get_main_queue()) {
                    completionCallback()
                }
            }
        }
    }
    
    func save() {
        if !self.privateContext.hasChanges && !self.managedObjectContext.hasChanges {
            return
        }
        
        self.managedObjectContext.performBlockAndWait() {
            var error: NSError?
            
            self.managedObjectContext.save(&error)
            if error == nil {
                println("WARNING: COULDN'T SAVE MAIN CONTEXT!")
            }
            
            self.privateContext.performBlock() {
                self.privateContext.save(&error)
                if error == nil {
                    println("WARNING: COULDN'T SAVE THE PRIVATE CONTEXT!")
                }
            }
        }
    }
}
