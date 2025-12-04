import UIKit
import CoreData

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var plants: [PlantEntity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Watering Schedule", comment: "Title for watering schedule")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPlantsData()
        tableView.reloadData()
    }

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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }

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
