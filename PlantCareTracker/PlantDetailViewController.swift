import UIKit

class PlantDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var wateringFrequencyTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var plant: Plant?
    var onSave: ((Plant) -> Void)?  // Callback to save changes
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        // Create plant (either new or updated)
        let plantToSave = Plant(
            id: plant?.id ?? UUID(),  // Use existing ID or create new one
            name: nameTextField.text ?? "",
            species: speciesTextField.text ?? "",
            lastWatered: plant?.lastWatered ?? Date(),  // Use existing date or today
            wateringFrequency: Int(wateringFrequencyTextField.text ?? "7") ?? 7,
            notes: notesTextView.text ?? ""
        )
        
        // Call the save callback
        onSave?(plantToSave)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Display the plant information if we have a plant
        if let plant = plant {
            nameTextField.text = plant.name
            speciesTextField.text = plant.species
            wateringFrequencyTextField.text = "\(plant.wateringFrequency)"
            notesTextView.text = plant.notes
        }
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    // Function to dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
