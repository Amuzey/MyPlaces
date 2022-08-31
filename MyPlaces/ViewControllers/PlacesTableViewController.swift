//
//  PlacesTableViewController.swift
//  MyPlaces
//
//  Created by Алексей on 28.08.2022.
//

import UIKit
import RealmSwift

class PlacesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var sotringSegmentedControl: UISegmentedControl!
    
    // MARK: - Public Properties
    var places: Results<Place>!
    
    // MARK: - Private Properties
    private var ascendingSorting = true
    
    // MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let newPlaceVC = segue.destination as? NewPlaceTableViewController else { return }
            let place = places[indexPath.row]
            newPlaceVC.curentPlace = place
        }
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.isEmpty ? 0 : places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "place", for: indexPath) as? PlaceCell else { return UITableViewCell() }
        let place = places[indexPath.row]
        
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.placeImage.image = UIImage(data: place.imageData!)
        
        cell.placeImage.layer.cornerRadius = cell.placeImage.frame.size.height / 2
        cell.placeImage.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.delete(self.places[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    
    // MARK: IBActions
    @IBAction func selectionSorting(_ sender: Any) {
        sorting()
    }
    
    @IBAction func reversedSorting(_ sender: Any) {
        ascendingSorting.toggle()
        sorting()
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else { return }
        newPlaceVC.savePlace()
        tableView.reloadData()
    }
    
    // MARK: - Private Methods
    private func sorting() {
        if sotringSegmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
}


