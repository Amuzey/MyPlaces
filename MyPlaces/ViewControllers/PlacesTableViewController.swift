//
//  PlacesTableViewController.swift
//  MyPlaces
//
//  Created by Алексей on 28.08.2022.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    
    let places = Place.getPlaces()
    
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
        
        cell.nameLabel.text = places[indexPath.row].name
        cell.locationLabel.text = places[indexPath.row].location
        cell.typeLabel.text = places[indexPath.row].type
        cell.placeImage.image = UIImage(named: places[indexPath.row].image)
        cell.placeImage.layer.cornerRadius = cell.placeImage.frame.size.height / 2
        
        return cell
    }
}


