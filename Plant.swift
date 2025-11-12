import Foundation

struct Plant {
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

