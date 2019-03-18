//
//  CoreDataManager.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/18.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import CoreData
import UIKit

final class CoreDataManager {
    // MARK: Properties
    
    private let modelName: String
    
    private(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = self.privateManagedObjectContext
        
        return managedObjectContext
    }()
    
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelExtension = "momd"
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: modelExtension) else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        return persistentStoreCoordinator
    }()
    
    // MARK: - CoreDataManagerCompletionHandler
    
    public typealias CoreDataManagerCompletionHandler = () -> ()
    
    private let completionHandler: CoreDataManagerCompletionHandler
    
    // MARK: - Initialization
    init(modelName: String, completionHandler: @escaping CoreDataManagerCompletionHandler) {
        self.modelName = modelName
        self.completionHandler = completionHandler
        
        // Setup Core Data Stack
        setupCoreDataStack()
        
        // Setup NotificationHandling
        setupNotificationHandling()
        
    }
    
    // MARK: - Notification Handling
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges(_:)), name: UIApplication.willTerminateNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveChanges(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    // MARK: - Setup Core Data Stack
    private func setupCoreDataStack() {
        guard let persistentStoreCoordinator = mainManagedObjectContext.persistentStoreCoordinator else {
            fatalError("Unable to Setup Core Data Stack")
        }
        
        DispatchQueue.global().async {
            self.addPersistentStore(to: persistentStoreCoordinator)
            
            DispatchQueue.main.async {
                self.completionHandler()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func addPersistentStore(to persistentStoreCoordinator: NSPersistentStoreCoordinator) {
        let fileManager = FileManager.default
        let persistentStoreName = "\(self.modelName).sqlite"
        
        // Document Directory URL
        let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // Persistent Store URL
        let persistentStoreURL = documentURL.appendingPathComponent(persistentStoreName)
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                           NSInferMappingModelAutomaticallyOption: true]
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: options)
        } catch {
            fatalError("Unable to Add Persistent Store")
        }
    }
    
    @objc private func saveChanges(_ notification: NSNotification) {
        mainManagedObjectContext.perform {
            do {
                if self.mainManagedObjectContext.hasChanges {
                    try self.mainManagedObjectContext.save()
                }
            } catch {
                self.mainManagedObjectContext.rollback()
                let saveError = error
                print("Unable to Save Changes of Main Managed Object Context")
                print("\(saveError.localizedDescription)")
            }
            
            self.privateManagedObjectContext.perform {
                do {
                    if self.privateManagedObjectContext.hasChanges {
                        try self.privateManagedObjectContext.save()
                    }
                } catch {
                    let saveError = error
                    print("Unable to Save Changes of Private Managed Object Context")
                    print("\(saveError.localizedDescription)")
                }
            }
        }
    }
 }
