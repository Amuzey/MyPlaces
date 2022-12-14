//
//  NewPlaceTableViewController.swift
//  MyPlaces
//
//  Created by Алексей on 28.08.2022.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var placeImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var typeTextField: UITextField!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var ratingControl: RatingControl!
    
    // MARK: - Public properties
    var curentPlace: Place!
    var imageIsChanged = false
    
    // MARK: - Private Properties
    private let camera = UIImage(systemName: "camera")
    private let library = UIImage(systemName: "photo")
    
    // MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        nameTextField.addTarget(
            self,
            action: #selector(textFieldChanged),
            for: .editingChanged
        )
        setupEditScreen()
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            showAlert()
        } else {
            view.endEditing(true)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "mapKit" { return }
        guard let mapVC = segue.destination as? MapViewController else { return }
        mapVC.place.name = nameTextField.text!
        mapVC.place.location = locationTextField.text
        mapVC.place.type = typeTextField.text
        mapVC.place.imageData = placeImageView.image?.pngData()
        
        
    }
    
    // MARK: - IBActions
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    private func setupEditScreen() {
        
        if curentPlace != nil {
            
            setupNavigationBar()
            imageIsChanged = true
            guard let data = curentPlace?.imageData, let image = UIImage(data: data) else { return }
            
            placeImageView.image = image
            placeImageView.contentMode = .scaleAspectFill
            nameTextField.text = curentPlace?.name
            locationTextField.text = curentPlace?.location
            typeTextField.text = curentPlace?.type
            ratingControl.rating = Int(curentPlace.rating)
        }
    }
    
    private func setupNavigationBar() {
        
        title = curentPlace?.name
        navigationItem.leftBarButtonItem = nil
        saveButton.isEnabled = true
    }
}

// MARK: - Text Field Delegate
extension NewPlaceTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        if nameTextField.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    func savePlace() {
        
        let image = imageIsChanged ? placeImageView.image : #imageLiteral(resourceName: "imagePlaceholder")
        let imageData = image?.pngData()
        
        let newPlace = Place(
            name: nameTextField.text!,
            location: locationTextField.text,
            type: typeTextField.text,
            imageData: imageData,
            rating: Double(ratingControl.rating)
        )
        
        if curentPlace != nil {
            try! realm.write {
                curentPlace?.name = newPlace.name
                curentPlace?.location = newPlace.location
                curentPlace?.type = newPlace.type
                curentPlace?.imageData = newPlace.imageData
                curentPlace?.rating = newPlace.rating
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
    }
}

// MARK: - Alert View Controlle
extension NewPlaceTableViewController {
    private func showAlert() {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        let photoAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        photoAction.setValue(camera, forKey: "image")
        photoAction.setValue(CATextLayerAlignmentMode.left,
                             forKey: "titleTextAlignment")
        
        let libraryAction = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        libraryAction.setValue(library, forKey: "image")
        libraryAction.setValue(CATextLayerAlignmentMode.left,
                               forKey: "titleTextAlignment")
        
        let canсelAction = UIAlertAction(title: "Canсel", style: .cancel)
        
        alert.addAction(photoAction)
        alert.addAction(libraryAction)
        alert.addAction(canсelAction)
        
        present(alert, animated: true)
    }
}

// MARK: - Work with image
extension NewPlaceTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        placeImageView.image = info[.editedImage] as? UIImage
        placeImageView.contentMode = .scaleAspectFill
        placeImageView.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
    }
}
