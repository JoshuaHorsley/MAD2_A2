//  FILE:        ViewController.swift
//  PROJECT:     PlantCareTracker
//  COURSE:      Mobile Application Development 2 
//  DATE:        12 - 04 - 2025
//  AUTHORS:     Josh Horsley, Will Lee, Jack Prudnikowicz, Kalina Cathcart 
//  DESCRIPTION: This view controller manages the watering schedule display,
//               allowing plants to be sorted by when they need to be watered next.

import UIKit
import CoreData


// Class:       ScheduleViewController
// Description: View controller responsible for displaying a sorted list of plants.
///             Sorting is based on their watering schedule, showing which plants need water soonest
class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Table view for plant watering table
    @IBOutlet weak var tableView: UITableView!

    // Array for plants and their watering schedule
    var plants: [PlantEntity] = []

    // FUNCTION:    viewDidLoad
    // PARAMETERS:  none
    // RETURNS:     void
    // DESCRIPTION: This function is called when the view is first loaded into memory. 
    //              Sets the localized navigation title for the watering schedule screen.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Watering Schedule", comment: "Title for watering schedule")
    }
    
    // FUNCTION:     viewWillAppear
    // PARAMETERS:   animated - Bool noting if the appearance should be animated
    // RETURNS:      void
    // DESCRIPTION:  This function is called just before the view appears on screen.
    //               Refreshes plant data and reloads the table view to reflect any changes.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPlantsData()
        tableView.reloadData()
    }

    // FUNCTION:    loadPlantsData
    // PARAMETERS:  none
    // RETURNS:     void
    // DESCRIPTION: This funciton loads plant data from the PlantListTableViewController and sorts plants by watering urgency.
    //              The plants that need watering the soonest appear at the top of the list.
    //              Calculates days until next watering for each plant based on last watered date and watering frequency.
    func loadPlantsData() {
        if let tabBarController = self.tabBarController {
            if let navController = tabBarController.viewControllers?[0] as? UINavigationController {
                if let plantListVC = navController.viewControllers.first as? PlantListTableViewController {
                    plants = plantListVC.plants
                    
                    plants.sort { (plant1: PlantEntity, plant2: PlantEntity) -> Bool in
                        let days1 = Calendar.current.dateComponents([.day], from: plant1.lastWatered ?? Date(), to: Date()).day ?? 0
                        let daysUntil1 = Int(plant1.wateringFrequency) - days1
                        
                        let days2 = Calendar.current.dateComponents([.day], from: plant2.lastWatered ?? Date(), to: Date()).day ?? 0
                        let daysUntil2 = Int(plant2.wateringFrequency) - days2
                        
                        return daysUntil1 < daysUntil2
                    }
                }
            }
        }
    }

    // FUNCTION:     numberOfSections
    // PARAMETERS:   tableView - The table view requesting this information
    // RETURNS:      Int - The number of sections, which is always 1
    // DESCRIPTION:  This UITableViewDataSource method returns the number of sections in the table view. 
    //               This schedule view uses only 1 section.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // FUNCTION:    tableView
    // PARAMETERS:  tableView - The table view requesting this information
    //              section - The section index
    // RETURNS:     Int - The number of rows equal to the number of plants
    // DESCRIPTION: This UITableViewDataSource method returns the number of rows in the specified section. 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }
    
    // FUNCTION:    tableView
    // PARAMETERS:  tableView - The table view requesting the cell
    //              indexPath - The location of the row
    // RETURNS:     UITableViewCell - A cell displaying plant name and watering status
    // DESCRIPTION: This UITableViewDataSource method  configures and returns a cell for the given index path.
    //              Displays plant name and watering status with colour-coded urgency: red = today, orange = tomorrow, grey = later
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath)

        let plant = plants[indexPath.row]

        let daysSinceWatered = Calendar.current.dateComponents([.day], from: plant.lastWatered ?? Date(), to: Date()).day ?? 0
        let daysUntilNextWatering = Int(plant.wateringFrequency) - daysSinceWatered

        cell.textLabel?.text = plant.name

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
