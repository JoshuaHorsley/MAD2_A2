//  FILE:        PlantListTableViewController.swift
//  PROJECT:     PlantCareTracker
//  COURSE:      Mobile Application Development 2
//  DATE:        11-09-2025
//  AUTHORS:     Josh Horsley, Will Lee, Jack Prudnikowicz, Kalina Cathcart
//  DESCRIPTION: Manages the list of plants displayed in a table view.
//               Handles loading, saving, and deleting plants using Core Data.
//               Includes context menu for plant actions.

import UIKit
import CoreData

// CLASS:       PlantListTableViewController
// DESCRIPTION: Displays a list of the user's plants and their basic information.
//              Provides context menu for editing, marking as watered, and deleting plants.

class PlantListTableViewController: UITableViewController {
    
    var plants: [PlantEntity] = []
    let coreDataManager = CoreDataManager.shared

    // FUNCTION:    viewDidLoad
    // PARAMETERS:  none
    // RETURNS:     void
    // DESCRIPTION: This function is called when view is first loaded, in which it sets the navigation title and loads plants from Core Data.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("My Garden", comment: "Title for plant list")
        loadPlants()
    }

    // FUNCTION:    viewWillAppear
    // PARAMETERS:  animated - Bool indicating if appearance should be animated
    // RETURNS:     void
    // DESCRIPTION: This function is called before view appears on screen. It reloads plant data and refreshes table view.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPlants()
        tableView.reloadData()
    }
    
    // NAME:        loadPlants
    // PARAMETERS:  none
    // RETURNS:     void
    // DESCRIPTION: Fetches plants from Core Data. If none exist, loads sample plants.
    
    func loadPlants() {
        let fetchRequest: NSFetchRequest<PlantEntity> = PlantEntity.fetchRequest()
        
        do {
            plants = try coreDataManager.context.fetch(fetchRequest)
            if plants.isEmpty {
                loadSamplePlants()
            }
        } catch {
            print("Error fetching plants: \(error)")
        }
    }
    
    // NAME:        loadSamplePlants
    // PARAMETERS:  none
    // RETURNS:     void
    // DESCRIPTION: Creates sample plants.
    
    func loadSamplePlants() {
        let plant1 = PlantEntity(context: coreDataManager.context)
        plant1.id = UUID()
        plant1.name = "Kevin"
        plant1.species = "Money Tree"
        plant1.lastWatered = Date()
        plant1.wateringFrequency = 14
        plant1.notes = "Likes direct light"
        
        let plant2 = PlantEntity(context: coreDataManager.context)
        plant2.id = UUID()
        plant2.name = "Jake"
        plant2.species = "Snake Plant"
        plant2.lastWatered = Date()
        plant2.wateringFrequency = 7
        plant2.notes = "Very low maintenance"
        
        let plant3 = PlantEntity(context: coreDataManager.context)
        plant3.id = UUID()
        plant3.name = "Diefenbaker"
        plant3.species = "Dieffenbachia"
        plant3.lastWatered = Date()
        plant3.wateringFrequency = 7
        plant3.notes = "Water when soil is dry"
        
        coreDataManager.saveContext()
        loadPlants()
    }

    // FUNCTION:    numberOfSections
    // PARAMETERS:  tableView - The table view requesting this information
    // RETURNS:     Int - The number of sections (always 1)
    // DESCRIPTION: This UITableViewDataSource method returns the number of sections in the table view, which will always be 1.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // FUNCTION:    tableView
    // PARAMETERS:  tableView - The table view requesting this information
    //              section - The section index
    // RETURNS:     Int - The number of rows, equal to number of plants
    // DESCRIPTION: This UITableViewDataSource method returns the number of rows in the specified section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }

    // FUNCTION:    tableView
    // PARAMETERS:  tableView - The table view requesting the cell
    //              indexPath - The location of the row
    // RETURNS:     UITableViewCell - A configured cell displaying plant information
    // DESCRIPTION: Configures and returns a cell for the given index path. 
    //              Displays plant name, species, and a water drop icon if plant needs watering today or is overdue.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath)
        
        let plant = plants[indexPath.row]
        
        cell.textLabel?.text = plant.name
        cell.detailTextLabel?.text = plant.species
        
        let daysSinceWatered = Calendar.current.dateComponents([.day], from: plant.lastWatered ?? Date(), to: Date()).day ?? 0
        let daysUntilNextWatering = Int(plant.wateringFrequency) - daysSinceWatered
        
        if daysUntilNextWatering <= 0 {
            cell.imageView?.image = UIImage(systemName: "drop.fill")
            cell.imageView?.tintColor = .systemBlue
        } else {
            cell.imageView?.image = UIImage(systemName: "leaf.fill")
            cell.imageView?.tintColor = .systemGreen
        }
        
        return cell
    }

    // FUNCTION:    tableView
    // PARAMETERS:  tableView - The table view
    //              editingStyle - The editing style, whether insert or delete
    //              indexPath - The row being edited
    // RETURNS:     void
    // DESCRIPTION: This function handles swipe-to-delete action. 
    //              Deletes the plant from Core Data and removes the row from the table view with a fade animation.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let plantToDelete = plants[indexPath.row]
            coreDataManager.context.delete(plantToDelete)
            coreDataManager.saveContext()
            
            plants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // NAME:        tableView(_:contextMenuConfigurationForRowAt:point:)
    // PARAMETERS:  tableView: UITableView - The table view
    //              indexPath: IndexPath - The row being long-pressed
    //              point: CGPoint - The location of the long-press
    // RETURNS:     UIContextMenuConfiguration - The menu configuration
    // DESCRIPTION: Creates a context menu when user long-presses a plant cell.
    //              Menu includes Edit, Mark as Watered, and Delete options.
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let plant = plants[indexPath.row]
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (actions) -> UIMenu? in
            
            // Edit action
            let editAction = UIAction(title: NSLocalizedString("Edit", comment: "Edit plant"), image: UIImage(systemName: "pencil")) { _ in
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                self.performSegue(withIdentifier: "ShowPlantDetail", sender: self)
            }
            
            // Delete action
            let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: "Delete plant"), image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.coreDataManager.context.delete(plant)
                self.coreDataManager.saveContext()
                self.plants.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            return UIMenu(title: plant.name ?? "Plant", children: [editAction, deleteAction])
        }
        
        return config
    }


    // FUNCTION:    prepare(for:sender:)
    // PARAMETERS:  segue - The segue being performed
    //              sender - The object that triggered the segue
    // RETURNS:     void
    // DESCRIPTION: This function prepares navigation to PlantDetailViewController.
    //              It passes the selected plant for editing or nil if adding a new plant. Also passes CoreDataManager instance.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? PlantDetailViewController {
            if segue.identifier == "ShowPlantDetail" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    detailVC.plant = plants[indexPath.row]
                    detailVC.coreDataManager = CoreDataManager.shared
                }
            } else if segue.identifier == "AddPlant" {
                detailVC.plant = nil
                detailVC.coreDataManager = CoreDataManager.shared
            }
        }
    }
}
