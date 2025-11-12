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
        // Create plant (either new or updated)
        let plantToSave = Plant(
            id: plant?.id ?? UUID(),
            name: nameTextField.text ?? "",
            species: speciesTextField.text ?? "",
            lastWatered: plant?.lastWatered ?? Date(),
            wateringFrequency: Int(wateringFrequencyTextField.text ?? "7") ?? 7,
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
}
