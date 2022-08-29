//
//  Place.swift
//  MyPlaces
//
//  Created by Алексей on 28.08.2022.
//

import UIKit

struct Place {
    
    let barNameimage: String?
    let name: String
    let location: String?
    let type: String?
    let image: UIImage?
    
    
    
    static private let restourantList = [
        "Bar and kitchen IZAKAYA",
        "Бар «Сплетни»",
        "Double Grill & Bar",
        "Винный бар «БИО ШМИО»",
        "Рюмочная Мелодия",
        "Бар «Коллектив»",
        "Винотека Dolce",
        "«Самоцвет»"
    ]
    
    static func getPlaces() -> [Place] {
        
        var places: [Place] = []
        
        for place in restourantList {
            places.append(Place(barNameimage: place, name: place, location: "Екатеринбург", type: "Бар", image: nil))
        }
        return places
    }
}
