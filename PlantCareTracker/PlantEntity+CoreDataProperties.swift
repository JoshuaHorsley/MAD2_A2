//
//  PlantEntity+CoreDataProperties.swift
//  PlantCareTracker
//
//  Created by Student on 2025-12-01.
//
//

import Foundation
import CoreData


extension PlantEntity {

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

extension PlantEntity : Identifiable {

}
