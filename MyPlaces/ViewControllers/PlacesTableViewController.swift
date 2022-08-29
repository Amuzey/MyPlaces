//
//  PlacesTableViewController.swift
//  MyPlaces
//
//  Created by Алексей on 28.08.2022.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    
    var places = Place.getPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My places"
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "place", for: indexPath) as? PlaceCell else { return UITableViewCell() }
        let place = places[indexPath.row]
        
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        
        if place.image == nil {
            cell.placeImage.image = UIImage(named: place.barNameimage!)
        } else {
            cell.placeImage.image = place.image
        }
            cell.placeImage.layer.cornerRadius = cell.placeImage.frame.size.height / 2
        
        return cell
    }
    
    @IBAction func saveAction(segue: UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else { return }
        newPlaceVC.saveNewPlace()
        
        places.append(newPlaceVC.newPlace)
        tableView.reloadData()
    }
}


