//
//  Aisle.swift
//  MediStock
//
//  Created by Thibault Giraudon on 15/09/2025.
//

import Foundation


/// Model representing an aisle.
///
/// `Aisle` stores all information about an aisle, its name, icon , icon's color and medicines stocked.
struct Aisle: Identifiable, Hashable, Equatable {
    
    // MARK: - Propeties
    
    /// The unique identifier of the aisle.
    var id = UUID().uuidString
    
    /// The aisle's name
    var name: String
    
    /// The aisle's diplayed icon.
    var icon: String
    
    /// The icon foreground color.
    var color: String
    
    /// The list of medicines stocked in the ailse.
    var medicines: [String]
    
    // MARK: - Initializers
    
    /// Creates a new `Aisle` instance from provided information
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the aisle.
    ///   - name: The name of the aisle.
    ///   - icon: The symbol or icon representing the aisle.
    ///   - color: The foreground color associated with the icon.
    ///   - medicines: A list of medicine names stored in the aisle.
    ///
    init(id: String = UUID().uuidString, name: String, icon: String, color: String, medicines: [String] = []) {
        self.id = id
        self.name = name
        self.medicines = medicines
        self.icon = icon
        self.color = color
    }
    
    /// Creates a new `Aisle` instance from a dictionary.
    ///
    /// This failable initializer attempts to build an `Aisle` using the values
    /// provided in the given dictionary. If any required key is missing or
    /// contains an invalid type, initialization will fail and return `nil`.
    ///
    /// - Parameter data: A dictionary containing the aisle's properties.
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
    
    // MARK: - Methods
    
    /// Converts the `Aisle` into a dictionary representation.
    ///
    /// Useful when saving the aisle in a database.
    ///
    /// - Returns: A `[String: Any]` dictionary containing all the aisle properties.
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
}
