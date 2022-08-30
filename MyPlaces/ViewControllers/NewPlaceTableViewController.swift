//
//  NewPlaceTableViewController.swift
//  MyPlaces
//
//  Created by Алексей on 28.08.2022.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {
    
    @IBOutlet var placeImageView: UIImageView!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var locationRextField: UITextField!
    @IBOutlet var typeTextField: UITextField!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    private let camera = #imageLiteral(resourceName: "camera")
    private let library = #imageLiteral(resourceName: "photo")
    
    var curentPlace: Place?
    var imageIsChanged = false
    
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
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            showAlert()
        } else {
            view.endEditing(true)
        }
    }
    
    //MARK: - Private Methods
    private func setupEditScreen() {
        
        if curentPlace != nil {
            
            setupNavigationBar()
            imageIsChanged = true
            guard let data = curentPlace?.imageData, let image = UIImage(data: data) else { return }
            
            placeImageView.image = image
            placeImageView.contentMode = .scaleAspectFill
            nameTextField.text = curentPlace?.name
            locationRextField.text = curentPlace?.location
            typeTextField.text = curentPlace?.type
        }
    }
    private func setupNavigationBar() {
        
        title = curentPlace?.name
        navigationItem.leftBarButtonItem = nil
        saveButton.isEnabled = true
    }
}

//MARK: - Text Field Delegate
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
        
        var image: UIImage?
        
        if imageIsChanged {
            image = placeImageView.image
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
        
        let newPlace = Place(
            name: nameTextField.text!,
            location: locationRextField.text,
            type: typeTextField.text,
            imageData: imageData
        )
        
        if curentPlace != nil {
            try! realm.write {
                curentPlace?.name = newPlace.name
                curentPlace?.location = newPlace.location
                curentPlace?.type = newPlace.type
                curentPlace?.imageData = newPlace.imageData
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
    }
}


//MARK: - Alert View Controlle
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

//MARK: - Work with image
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
