import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // We'll access the plants from the list view controller
    var plants: [Plant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Get the plants data and calculate schedule
        loadPlantsData()
        tableView.reloadData()
    }
    
    func loadPlantsData() {
        // Get reference to the plant list controller
        if let tabBarController = self.tabBarController {
            if let navController = tabBarController.viewControllers?[0] as? UINavigationController {
                if let plantListVC = navController.viewControllers.first as? PlantListTableViewController {
                    plants = plantListVC.plants
                }
            }
        }
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath)
        
        let plant = plants[indexPath.row]
        
        // Calculate days until next watering
        let daysSinceWatered = Calendar.current.dateComponents([.day], from: plant.lastWatered, to: Date()).day ?? 0
        let daysUntilNextWatering = plant.wateringFrequency - daysSinceWatered
        
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
