//  FILE:        CoreDataManager.swift
//  PROJECT:     PlantCareTracker
//  COURSE:      Mobile Application Development 2
//  DESCRIPTION: Manages Core Data stack and database operations

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PlantCareTracker")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Core Data Error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - Context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Core Data save successful")
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
