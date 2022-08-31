//
//  PlaceCell.swift
//  MyPlaces
//
//  Created by Алексей on 28.08.2022.
//

import UIKit

class PlaceCell: UITableViewCell {
    
    @IBOutlet var placeImage: UIImageView! {
        didSet {
            placeImage.clipsToBounds = true
            placeImage.layer.cornerRadius = placeImage.frame.size.height / 2
        }
    }
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    
}
