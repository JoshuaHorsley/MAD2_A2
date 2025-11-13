//  FILE:        Plant.swift
//  PROJECT:     PlantCareTracker
//  COURSE:      Mobile Application Development 2 
//  DATE:        11 - 05 - 2025
//  AUTHORS:     Josh Horsley, Will Lee, Jack Prudnikowicz, Kalina Cathcart 
//  DESCRIPTION: This file defines the Plant data model used in the PlantCareTracker app.

import Foundation


/*
 * STRUCT:      Plant
 * DESCRIPTION: Represents a single plant record with identifying information and care-related data. 
 */
struct Plant: Codable {
    var id: UUID
    var name: String
    var species: String
    var lastWatered: Date
    var wateringFrequency: Int
    var notes: String
    
    init(id: UUID = UUID(), name: String, species: String, lastWatered: Date, wateringFrequency: Int, notes: String) {
        self.id = id
        self.name = name
        self.species = species
        self.lastWatered = lastWatered
        self.wateringFrequency = wateringFrequency
        self.notes = notes
    }
}

