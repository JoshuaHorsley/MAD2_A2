//  FILE:        ScheduleViewController.swift
//  PROJECT:     PlantCareTracker
//  COURSE:      Mobile Application Development 2
//  DATE:        11-05-2025
//  AUTHORS:     Josh Horsley, Will Lee, Jack Prudnikowicz, Kalina Cathcart
//  DESCRIPTION: View controller that displays a watering schedule for all plants.
//               Shows plants sorted by watering priority with color-coded urgency indicators, and refreshes data each time the view appears.

import UIKit

// CLASS: ScheduleViewController
// DESCRIPTION: This class holds the code to determine how plants are sorterd, when to be watered, and visual indicators for urgency 
class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Table view displaying the water schedule 
    @IBOutlet weak var tableView: UITableView!
    
    // Array for plants being displayed 
    var plants: [Plant] = []

    // NAME:        viewDidLoad
    // PARAMETERS:  none
    // RETURNS:     void
    // DESCRIPTION: Called after the view controller's view is loaded into memory.
    //              Sets up the navigation title with localization support.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Watering Schedule", comment: "Title for watering schedule")
    }

    // NAME:        viewWillAppear
    // PARAMETERS:  animated: Bool to indicate whether the view appearance should be animated.
    // RETURNS:     none
    // DESCRIPTION: Called each time the view is about to appear on screen to reload the plant data in order to keep the schedule is up to date.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the plants data and calculate schedule
        loadPlantsData()
        tableView.reloadData()
    }

    // NAME:        loadPlantsData
    // PARAMETERS:  none
    // RETURNS:     void
    // DESCRIPTION: Retrieves the list of plants from the PlantListTableViewController, determines how soon each plant needs watering, and sorts them by urgency 
    func loadPlantsData() {
        
        // Get reference to the plant list controller
        if let tabBarController = self.tabBarController {
            if let navController = tabBarController.viewControllers?[0] as? UINavigationController {
                if let plantListVC = navController.viewControllers.first as? PlantListTableViewController {
                    plants = plantListVC.plants
                    
                    // Sort plants by days until next watering (soonest first)
                    plants.sort { plant1, plant2 in
                        let days1 = Calendar.current.dateComponents([.day], from: plant1.lastWatered, to: Date()).day ?? 0
                        let daysUntil1 = plant1.wateringFrequency - days1
                        
                        let days2 = Calendar.current.dateComponents([.day], from: plant2.lastWatered, to: Date()).day ?? 0
                        let daysUntil2 = plant2.wateringFrequency - days2
                        
                        return daysUntil1 < daysUntil2
                    }
                }
            }
        }
    }
    
    
    // NAME:        numberOfSections
    // PARAMETERS:  tableView: UITableView - The table view requesting this information.
    // RETURNS:     Int - The number of sections in the table view.
    // DESCRIPTION: Returns the number of sections to be displayed in the schedule. 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // NAME:        tableView(_:numberOfRowsInSection:)
    // PARAMETERS:  tableView: UITableView - The table view requesting this information.
    //              section: Int - The index of the section.
    // RETURNS:     Int - The number of rows (plants) to display in the section.
    // DESCRIPTION: Returns the number of plants that are currently in the schedule.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }


    // NAME:        tableView(_:cellForRowAt:)
    // PARAMETERS:  tableView: UITableView - The table view requesting the cell.
    //              indexPath: IndexPath - The index path specifying the row and section.
    // RETURNS:     UITableViewCell - A configured table view cell displaying plant watering info.
    // DESCRIPTION: Sets up and returns each table view cell to display the plant's name, days until next watering, and urgency indicators.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath)
        
        let plant = plants[indexPath.row]
        
        // Calculate how many days have passed since last watering
        let daysSinceWatered = Calendar.current.dateComponents([.day], from: plant.lastWatered, to: Date()).day ?? 0
        let daysUntilNextWatering = plant.wateringFrequency - daysSinceWatered

        // Set the plant name in the main text label
        cell.textLabel?.text = plant.name

        // Display urgency message and color based on watering schedule
        if daysUntilNextWatering <= 0 {
            cell.detailTextLabel?.text = "Water today!"
            cell.detailTextLabel?.textColor = .red
        } else if daysUntilNextWatering == 1 {
            cell.detailTextLabel?.text = "Water tomorrow"
            cell.detailTextLabel?.textColor = .orange
        } else {
            cell.detailTextLabel?.text = "Water in \(daysUntilNextWatering) days"
            cell.detailTextLabel?.textColor = .gray
        }
        
        return cell
    }
}
