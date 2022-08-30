//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Алексей on 30.08.2022.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place) {
    try! realm.write {
          
        realm.add(place)
        }
    }
    
    // MARK: - CRUD
    static func create() {
        
    }
    
    static func fetchData() {
        
    }
    
    static func update(_ place: Place) {
       
    }
    
    static func delete(_ place: Place) {
        
        try? realm.write {
            realm.delete(place)
        }
    }
}
