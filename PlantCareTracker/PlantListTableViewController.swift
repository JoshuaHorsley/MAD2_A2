//  FILE:        PlantListTableViewController.swift
//  PROJECT:     PlantCareTracker
//  COURSE:      Mobile Application Development 2
//  DATE:        11-09-2025
//  AUTHORS:     Josh Horsley, Will Lee, Jack Prudnikowicz, Kalina Cathcart
//  DESCRIPTION: Manages the list of plants displayed in a table view.
//               Handles loading, saving, and deleting plants, as well as navigation to the plant detail view for adding or editing plants.

import UIKit

// CLASS:       PlantListTableViewController
// DESCRIPTION: Displays a list of the user's plants and their basic information.
class PlantListTableViewController: UITableViewController {
    
    // Array to store all plants
    var plants: [Plant] = []
    
    // File path for saving plants data
    var plantsFilePath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("plants.json")
    }


    // NAME:        viewDidLoad
    // PARAMETERS:  none
    // RETURNS:     void
    // DESCRIPTION: Called when the view is first loaded into memory.
    //              Sets the title and loads existing plants from storage, or sample data if none exists.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title for the navigation bar with localization
        self.title = NSLocalizedString("My Garden", comment: "Title for plant list")
        
        // Load plants from file, or create sample plants if file doesn't exist
        loadPlants()
    }
    
    // NAME:        viewWillAppear
    // PARAMETERS:  animated: Bool - Indicates if the appearance is animated
    // RETURNS:     void
    // DESCRIPTION: Called each time the view is about to appear.
    //              Refreshes the table view to show any updated plant information.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload table data when returning to this screen
        tableView.reloadData()
    }
    
    // NAME:        loadPlants
    // PARAMETERS:  none
    // RETURNS:     void
    // DESCRIPTION: Attempts to load the saved plants from a JSON file in the app's document directory.
    //              If the file doesn’t exist or an error occurs, loads default sample plants instead.
    func loadPlants() {
        if FileManager.default.fileExists(atPath: plantsFilePath.path) {
            do {
                let data = try Data(contentsOf: plantsFilePath)
                let decoder = JSONDecoder()
                plants = try decoder.decode([Plant].self, from: data)
            } catch {
                print("Error loading plants: \(error)")
                loadSamplePlants()
            }
        } else {
            loadSamplePlants()
        }
    }
    
    // NAME:        savePlants
    // PARAMETERS:  none
    // RETURNS:     void
    // DESCRIPTION: Encodes the plants array into JSON format and writes it to the file path for persistence.
    func savePlants() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(plants)
            try data.write(to: plantsFilePath)
        } catch {
            print("Error saving plants: \(error)")
        }
    }
    
    // NAME:        loadSamplePlants
    // PARAMETERS:  none
    // RETURNS:     void
    // DESCRIPTION: Creates a few sample plants to display when no saved data exists.
    //              These examples help populate the list for first-time users.
    func loadSamplePlants() {
        let plant1 = Plant(name: "Monstera", species: "Monstera Deliciosa", lastWatered: Date(), wateringFrequency: 7, notes: "Likes indirect light")
        let plant2 = Plant(name: "Snake Plant", species: "Sansevieria", lastWatered: Date(), wateringFrequency: 14, notes: "Very low maintenance")
        let plant3 = Plant(name: "Pothos", species: "Epipremnum aureum", lastWatered: Date(), wateringFrequency: 5, notes: "Water when soil is dry")
        
        plants = [plant1, plant2, plant3]
        savePlants()
    }


     // NAME:        numberOfSections
    // PARAMETERS:  tableView: UITableView - The table view requesting the number of sections.
    // RETURNS:     Int - Number of sections in the table (always one).
    // DESCRIPTION: Returns how many sections to display in the table view.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // NAME:        tableView(_:numberOfRowsInSection:)
    // PARAMETERS:  tableView: UITableView - The table view requesting the number of rows.
    //              section: Int - The index of the section.
    // RETURNS:     Int - Number of plants to display.
    // DESCRIPTION: Returns the total number of plants currently in the list.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }

    // NAME:        tableView(_:cellForRowAt:)
    // PARAMETERS:  tableView: UITableView - The table view requesting the cell.
    //              indexPath: IndexPath - The index path of the cell.
    // RETURNS:     UITableViewCell - Configured cell displaying plant information.
    // DESCRIPTION: Configures each table view cell to show the plant's name, species,
    //              and an icon that visually indicates if the plant needs watering.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath)
        
        // Get the plant for this row
        let plant = plants[indexPath.row]
        
        // Configure the cell
        cell.textLabel?.text = plant.name
        cell.detailTextLabel?.text = plant.species
        
        // Calculate if plant needs watering today
        let daysSinceWatered = Calendar.current.dateComponents([.day], from: plant.lastWatered, to: Date()).day ?? 0
        let daysUntilNextWatering = plant.wateringFrequency - daysSinceWatered
        
        // Show water droplet if needs watering, otherwise leaf
        if daysUntilNextWatering <= 0 {
            cell.imageView?.image = UIImage(systemName: "drop.fill")
            cell.imageView?.tintColor = .systemBlue
        } else {
            cell.imageView?.image = UIImage(systemName: "leaf.fill")
            cell.imageView?.tintColor = .systemGreen
        }
        
        return cell
    }
    
    // NAME:        tableView(_:commit:forRowAt:)
    // PARAMETERS:  tableView: UITableView - The table view performing the action.
    //              editingStyle: UITableViewCell.EditingStyle - The editing style (e.g., delete).
    //              indexPath: IndexPath - The index path of the affected row.
    // RETURNS:     void
    // DESCRIPTION: Enables swipe-to-delete functionality. Removes a plant from the list and updates saved data.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the plant from the array
            plants.remove(at: indexPath.row)
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
            // Save the updated plants array
            savePlants()
        }
    }
    
    // NAME:        prepare(for:sender:)
    // PARAMETERS:  segue: UIStoryboardSegue - The segue object containing transition information.
    //              sender: Any? - The object that triggered the segue.
    // RETURNS:     void
    // DESCRIPTION: Prepares the destination view controller before navigation occurs.
    //              Passes the selected plant for editing, or sets up a new plant for creation.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? PlantDetailViewController {
            if segue.identifier == "ShowPlantDetail" {
                // Editing existing plant
                if let indexPath = tableView.indexPathForSelectedRow {
                    detailVC.plant = plants[indexPath.row]
                    // Set up the save callback
                    detailVC.onSave = { [weak self] updatedPlant in
                        self?.plants[indexPath.row] = updatedPlant
                        self?.savePlants()
                    }
                }
            } else if segue.identifier == "AddPlant" {
                // Creating new plant
                detailVC.plant = nil // No plant yet
                // Set up the save callback to add new plant
                detailVC.onSave = { [weak self] newPlant in
                    self?.plants.append(newPlant)
                    self?.savePlants()
                }
            }
        }
    }
}
