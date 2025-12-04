//  FILE:        CoreDataManager.swift
//  PROJECT:     PlantCareTracker
//  COURSE:      Mobile Application Development 2
//  DATE:        12 - 03 - 2025
//  AUTHORS:     Josh Horsley, Will Lee, Jack Prudnikowicz, Kalina Cathcart
//  DESCRIPTION: Manages Core Data stack and database operations

import Foundation
import CoreData


// CLASS:       CoreDataManager
// DESCRIPTION: Singleton class that manages the Core Data stack. 
//              Contains the persistent container, managed object context, and save operations.
class CoreDataManager {

    // Shared singleton instance of CoreDataManager
    static let shared = CoreDataManager()
    
    // Load the PlantCareTracker data model and persistent stores
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PlantCareTracker")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Core Data Error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // returns the view context from the persistent container.
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // FUNCTION:    saveContext
    // PARAMETERS:  none
    // RETURNS:     void
    // DESCRIPTION: Saves any changes in the managed object context to the persistent store.
    //              Only saves if there are pending changes, and prints error if save fails.
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
