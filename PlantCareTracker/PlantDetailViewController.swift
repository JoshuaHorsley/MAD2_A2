import UIKit

class PlantDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var wateringFrequencyTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var plant: Plant?
    var onSave: ((Plant) -> Void)?
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        // Validate input before saving
        guard let name = nameTextField.text, !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: NSLocalizedString("Invalid Input", comment: "Validation error title"),
                     message: NSLocalizedString("Please enter a plant name.", comment: "Empty name error"))
            return
        }
        
        guard let species = speciesTextField.text, !species.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: NSLocalizedString("Invalid Input", comment: "Validation error title"),
                     message: NSLocalizedString("Please enter a species name.", comment: "Empty species error"))
            return
        }
        
        guard let frequencyText = wateringFrequencyTextField.text,
              let frequency = Int(frequencyText),
              frequency >= 0 else {
            showAlert(title: NSLocalizedString("Invalid Input", comment: "Validation error title"),
                     message: NSLocalizedString("Please enter a valid watering frequency (positive number).", comment: "Invalid frequency error"))
            return
        }
        
        // All validation passed - create plant
        let plantToSave = Plant(
            id: plant?.id ?? UUID(),
            name: name.trimmingCharacters(in: .whitespaces),
            species: species.trimmingCharacters(in: .whitespaces),
            lastWatered: plant?.lastWatered ?? Date(),
            wateringFrequency: frequency,
            notes: notesTextView.text ?? ""
        )
        
        // Call the save callback
        onSave?(plantToSave)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style text fields
        nameTextField.borderStyle = .roundedRect
        speciesTextField.borderStyle = .roundedRect
        wateringFrequencyTextField.borderStyle = .roundedRect
        wateringFrequencyTextField.keyboardType = .numberPad
        
        // Add rounded corners to notes text view
        notesTextView.layer.cornerRadius = 8
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        notesTextView.clipsToBounds = true
        
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
    
    // Function to show alert dialogs
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert dismiss button"), style: .default))
        present(alert, animated: true)
    }
}
