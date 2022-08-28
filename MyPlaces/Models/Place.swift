//
//  Place.swift
//  MyPlaces
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

struct Place {
    
    let image: String
    let name: String
    let location: String
    let type: String
    
    
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
            places.append(Place(image: place, name: place, location: "Екатеринбург", type: "Бар"))
        }
        return places
    }
}
