//  FILE:        PlantDetailViewController.swift
//  PROJECT:     PlantCareTracker
//  COURSE:      Mobile Application Development 2
//  DATE:        12 - 03 - 2025
//  AUTHORS:     Josh Horsley, Will Lee, Jack Prudnikowicz, Kalina Cathcart
//  DESCRIPTION: This view controller allows users to add or edit a plant's details, validate the input, and save the data using Core Data.
//               Includes camera/photo library integration for plant photos.

import UIKit
import CoreData

// CLASS:        PlantDetailViewController
// DESCRIPTION:  This view controller allows users to add or edit a plant's details, validate the input, and save the data using Core Data.
//               Supports taking photos or selecting from library.

class PlantDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var wateringFrequencyTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    var plant: PlantEntity?
    var coreDataManager: CoreDataManager?
    var selectedPhoto: UIImage?

    /*
     * FUNCTION:    saveButtonTapped
     * PARAMETERS:  sender (UIBarButtonItem) - the Save button
     * RETURN:      none
     * DESCRIPTION: Validates user input and creates a new or updated PlantEntity object.
     */
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        // Validate input before saving
        guard let name = nameTextField.text, !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: NSLocalizedString("Invalid Input", comment: "Validation error title"),
                     message: NSLocalizedString("Please enter a plant name.", comment: "Empty name error"))
            return
        }

        // Validate species field
        guard let species = speciesTextField.text, !species.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: NSLocalizedString("Invalid Input", comment: "Validation error title"),
                     message: NSLocalizedString("Please enter a species name.", comment: "Empty species error"))
            return
        }

        // Validate watering frequency
        guard let frequencyText = wateringFrequencyTextField.text,
              let frequency = Int(frequencyText),
              frequency >= 0 else {
            showAlert(title: NSLocalizedString("Invalid Input", comment: "Validation error title"),
                     message: NSLocalizedString("Please enter a valid watering frequency (positive number).", comment: "Invalid frequency error"))
            return
        }
        
        // Get the context (use passed in manager or default)
        let context = coreDataManager?.context ?? CoreDataManager.shared.context
        let manager = coreDataManager ?? CoreDataManager.shared
        
        // If editing existing plant, update it. Otherwise, create new one
        if let existingPlant = plant {
            existingPlant.name = name.trimmingCharacters(in: .whitespaces)
            existingPlant.species = species.trimmingCharacters(in: .whitespaces)
            existingPlant.wateringFrequency = Int32(frequency)
            existingPlant.notes = notesTextView.text ?? ""
            
            // Save photo data if a new photo was selected
            if let photo = selectedPhoto {
                existingPlant.photoData = photo.jpegData(compressionQuality: 0.8)
            }
        } else {
            let newPlant = PlantEntity(context: context)
            newPlant.id = UUID()
            newPlant.name = name.trimmingCharacters(in: .whitespaces)
            newPlant.species = species.trimmingCharacters(in: .whitespaces)
            newPlant.lastWatered = Date()
            newPlant.wateringFrequency = Int32(frequency)
            newPlant.notes = notesTextView.text ?? ""
            
            // Save photo data if a photo was selected
            if let photo = selectedPhoto {
                newPlant.photoData = photo.jpegData(compressionQuality: 0.8)
            }
        }
        
        manager.saveContext()
        navigationController?.popViewController(animated: true)
    }

    /*
     * FUNCTION: viewDidLoad
     * PARAMETERS: none
     * RETURN: none
     * DESCRIPTION: Sets up UI appearance and populates fields if editing
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
        
        // Style the image view
        plantImageView.layer.cornerRadius = 8
        plantImageView.clipsToBounds = true
        plantImageView.contentMode = .scaleAspectFill
        
        // Display the plant information if we're editing a plant
        if let plant = plant {
            nameTextField.text = plant.name
            speciesTextField.text = plant.species
            wateringFrequencyTextField.text = "\(plant.wateringFrequency)"
            notesTextView.text = plant.notes
            
            // Load and display photo if one exists
            if let photoData = plant.photoData, let image = UIImage(data: photoData) {
                plantImageView.image = image
                selectedPhoto = image
            }
        }
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    /*
     * FUNCTION: dismissKeyboard
     * PARAMETERS: none
     * RETURN: none
     * DESCRIPTION: Dismisses the keyboard when called
     */
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /*
     * FUNCTION:    addPhotoButtonTapped
     * PARAMETERS:  sender (UIButton) - the Add Photo button
     * RETURN:      none
     * DESCRIPTION: Presents action sheet allowing user to choose photo from camera or library
     */
    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: NSLocalizedString("Add Photo", comment: "Photo picker title"),
                                           message: NSLocalizedString("Choose photo source", comment: "Photo source prompt"),
                                           preferredStyle: .actionSheet)
        
        // Camera option
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: "Camera option"), style: .default) { _ in
                self.presentImagePicker(sourceType: .camera)
            }
            actionSheet.addAction(cameraAction)
        }
        
        // Photo library option
        let libraryAction = UIAlertAction(title: NSLocalizedString("Choose from Library", comment: "Library option"), style: .default) { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }
        actionSheet.addAction(libraryAction)
        
        // Cancel option
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button"), style: .cancel)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    /*
     * FUNCTION:    presentImagePicker
     * PARAMETERS:  sourceType (UIImagePickerController.SourceType) - camera or photo library
     * RETURN:      none
     * DESCRIPTION: Presents the image picker with the specified source type
     */
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    /*
     * FUNCTION:    imagePickerController(_:didFinishPickingMediaWithInfo:)
     * PARAMETERS:  picker (UIImagePickerController) - the image picker
     *              info ([UIImagePickerController.InfoKey : Any]) - selected image info
     * RETURN:      none
     * DESCRIPTION: Called when user selects a photo. Updates the image view with selected photo.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            plantImageView.image = editedImage
            selectedPhoto = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            plantImageView.image = originalImage
            selectedPhoto = originalImage
        }
        
        picker.dismiss(animated: true)
    }
    
    /*
     * FUNCTION:    imagePickerControllerDidCancel
     * PARAMETERS:  picker (UIImagePickerController) - the image picker
     * RETURN:      none
     * DESCRIPTION: Called when user cancels photo selection
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    /*
     * FUNCTION:    showAlert
     * PARAMETERS:  title (String) - Title for the alert dialog
     *              message (String) - Message to display in the alert
     * RETURN:      none
     * DESCRIPTION: Displays an alert dialog with the provided title and message
     */
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert dismiss button"), style: .default))
        present(alert, animated: true)
    }
}
