//
//  PlacesTableViewController.swift
//  MyPlaces
//
//  Created by Алексей on 28.08.2022.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    
    var places = [
        "Bar and kitchen IZAKAYA",
        "Бар «Сплетни»",
        "Double Grill & Bar",
        "Винный бар «БИО ШМИО»",
        "Рюмочная Мелодия",
        "Бар «Коллектив»",
        "Винотека Dolce",
        "«Самоцвет»"
    ]
    
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
        
        
        cell.nameLabel.text = places[indexPath.row]
        cell.placeImage.image = UIImage(named: places[indexPath.row])
        cell.placeImage.layer.cornerRadius = cell.placeImage.frame.size.height / 2
        
        return cell
    }
    
    // MARK: - Table view Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        85
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


