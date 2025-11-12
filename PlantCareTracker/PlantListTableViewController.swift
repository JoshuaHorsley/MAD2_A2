import UIKit

class PlantListTableViewController: UITableViewController {
    
    // Array to store all plants
    var plants: [Plant] = []
    
    // File path for saving plants data
    var plantsFilePath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("plants.json")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title for the navigation bar with localization
        self.title = NSLocalizedString("My Garden", comment: "Title for plant list")
        
        // Load plants from file, or create sample plants if file doesn't exist
        loadPlants()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload table data when returning to this screen
        tableView.reloadData()
    }
    
    // Function to load plants from file
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
    
    // Function to save plants to file
    func savePlants() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(plants)
            try data.write(to: plantsFilePath)
        } catch {
            print("Error saving plants: \(error)")
        }
    }
    
    // Function to create sample plants
    func loadSamplePlants() {
        let plant1 = Plant(name: "Monstera", species: "Monstera Deliciosa", lastWatered: Date(), wateringFrequency: 7, notes: "Likes indirect light")
        let plant2 = Plant(name: "Snake Plant", species: "Sansevieria", lastWatered: Date(), wateringFrequency: 14, notes: "Very low maintenance")
        let plant3 = Plant(name: "Pothos", species: "Epipremnum aureum", lastWatered: Date(), wateringFrequency: 5, notes: "Water when soil is dry")
        
        plants = [plant1, plant2, plant3]
        savePlants()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }

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
    
    // Enable swipe to delete
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
    
    // MARK: - Navigation
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
