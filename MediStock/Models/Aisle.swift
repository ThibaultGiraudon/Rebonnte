//
//  Aisle.swift
//  MediStock
//
//  Created by Thibault Giraudon on 15/09/2025.
//

import Foundation

struct Aisle: Identifiable, Hashable, Equatable {
    var id = UUID().uuidString
    var name: String
    var icon: String
    var color: String
    var medicines: [String]
    
    func data() -> [String: Any] {
        let data: [String: Any] = [
            "id": self.id,
            "name": self.name,
            "medicines": self.medicines,
            "icon": self.icon,
            "color": self.color
        ]
        
        return data
    }
    
    init(id: String = UUID().uuidString, name: String, icon: String, color: String, medicines: [String] = []) {
        self.id = id
        self.name = name
        self.medicines = medicines
        self.icon = icon
        self.color = color
    }
    
    init?(_ data: [String: Any]) {
        guard let id = data["id"] as? String,
              let name = data["name"] as? String,
              let icon = data["icon"] as? String,
              let color = data["color"] as? String,
              let medicines = data["medicines"] as? [String] else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.medicines = medicines
        self.icon = icon
        self.color = color
    }
}
