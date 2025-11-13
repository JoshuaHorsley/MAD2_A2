//  FILE:        PlantDetailViewController.swift
//  PROJECT:     PlantCareTracker
//  COURSE:      Mobile Application Development 2 
//  DATE:        11 - 05 - 2025
//  AUTHORS:     Josh Horsley, Will Lee, Jack Prudnikowicz, Kalina Cathcart 
//  DESCRIPTION: This view controller allows users to add or edit a plant's details, validate the input, and save the data using a callback closure.

import UIKit

// CLASS:        PlantDetailViewController
// DESCRIPTION:  This view controller allows users to add or edit a plant's details, validate the input, and save the data using a callback closure.
class PlantDetailViewController: UIViewController {

    // Text fields for entering plant details
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var wateringFrequencyTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var plant: Plant?                // Holds the plant being edited (if any)
    var onSave: ((Plant) -> Void)?   // Closure that passes the saved plant back to the previous screen

    /*
     * FUNCTION:    saveButtonTapped
     * PARAMETERS:  sender (UIBarButtonItem) - the Save button
     * RETURN:      none
     * DESCRIPTION: Validates user input and creates a new or updated Plant object, and displays alerts if validation fails.
     */
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        // Validate input before saving
        guard let name = nameTextField.text, !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: NSLocalizedString("Invalid Input", comment: "Validation error title"),
                     message: NSLocalizedString("Please enter a plant name.", comment: "Empty name error"))
            return
        }

        // Validate species field (cannot be empty or only spaces)
        guard let species = speciesTextField.text, !species.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: NSLocalizedString("Invalid Input", comment: "Validation error title"),
                     message: NSLocalizedString("Please enter a species name.", comment: "Empty species error"))
            return
        }

        // Validate watering frequency (must be a non-negative integer)
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
        // Navigate back to the previous screen
        navigationController?.popViewController(animated: true)
    }

     /*
     * FUNCTION: viewDidLoad
     * PARAMETERS: none
     * RETURN: none
     * DESCRIPTION: Sets up UI appearance 
     */
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
    
     /*
     * FUNCTION: dismissKeyboard
     * PARAMETERS: none
     * RETURN: none
     * DESCRIPTION: Dismisses the keyboard when called.
     */
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /*
     * FUNCTION:    showAlert
     * PARAMETERS:  title (String) - Title for the alert dialog
     *              message (String) - Message to display in the alert
     * RETURN:      none
     * DESCRIPTION: Displays an alert dialog with the provided title and message.
     */
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert dismiss button"), style: .default))
        present(alert, animated: true)
    }
}
