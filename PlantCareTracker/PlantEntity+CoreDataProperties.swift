//  FILE:        PlantEntity+CoreDataProperties.swift
//  PROJECT:     PlantCareTracker
//  COURSE:      Mobile Application Development 2
//  DATE:        12-03-2025
//  AUTHORS:     Josh Horsley, Will Lee, Jack Prudnikowicz, Kalina Cathcart
//  DESCRIPTION: Core Data entity extension that defines properties and fetch request for the PlantEntity managed object.
            
import Foundation
import CoreData

// EXTENSION:   PlantEntity
// DESCRIPTION: Extends PlantEntity to provide Core Data property definitions and fetch request
extension PlantEntity {

    // FUNCTION:    fetchRequest
    // PARAMETERS:  none
    // RETURNS:     NSFetchRequest<PlantEntity> - A fetch request for PlantEntity objects
    // DESCRIPTION: Creates and returns a fetch request for retrieving PlantEntity objects from Core Data
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlantEntity> {
        return NSFetchRequest<PlantEntity>(entityName: "PlantEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var lastWatered: Date?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var species: String?
    @NSManaged public var wateringFrequency: Int32
    @NSManaged public var photoData: Data?

}

// EXTENSION:   PlantEntity (Identifiable)
// DESCRIPTION: Changes the PlantEntity to the Identifiable protocol for use with SwiftUI
extension PlantEntity : Identifiable {

}
