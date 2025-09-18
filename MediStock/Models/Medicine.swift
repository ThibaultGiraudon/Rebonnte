import Foundation

/// Represents a medicine stored in the inventory.
///
/// Each `Medicine` keeps track of its stock levels, location, and visual attributes.
struct Medicine: Identifiable, Codable, Equatable, Hashable {
    
    /// The unique identifier of the medicine.
    var id = UUID().uuidString
    
    /// The name of the medicine.
    var name: String
    
    /// The current stock quantity.
    var stock: Int
    
    /// The identifier of the aisle where the medicine is stored.
    var aisle: String
    
    /// The expected normal stock level.
    var normalStock: Int
    
    /// The stock level that triggers a warning threshold.
    var warningStock: Int
    
    /// The stock level that triggers an alert threshold.
    var alertStock: Int
    
    /// The symbol or icon representing the medicine.
    var icon: String
    
    /// The color associated with the medicine's icon.
    var color: String

    /// Initializes a new `Medicine`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier (default is a new UUID).
    ///   - name: The name of the medicine.
    ///   - stock: The current stock quantity.
    ///   - aisle: The identifier of the aisle where it is stored.
    ///   - normalStock: The expected normal stock level.
    ///   - warningStock: The threshold for a stock warning.
    ///   - alertStock: The threshold for a stock alert.
    ///   - icon: The symbol representing the medicine.
    ///   - color: The color of the medicine's icon.
    init(
        id: String = UUID().uuidString,
        name: String,
        stock: Int,
        aisle: String,
        normalStock: Int,
        warningStock: Int,
        alertStock: Int,
        icon: String,
        color: String
    ) {
        self.id = id
        self.name = name
        self.stock = stock
        self.aisle = aisle
        self.normalStock = normalStock
        self.warningStock = warningStock
        self.alertStock = alertStock
        self.icon = icon
        self.color = color
    }
    
    /// Creates a new `Medicine` instance from a dictionary.
    ///
    /// This failable initializer attempts to build an `Medicine` using the values
    /// provided in the given dictionary. If any required key is missing or
    /// contains an invalid type, initialization will fail and return `nil`.
    ///
    /// - Parameter data: A dictionary containing the medicine's properties.
    init?(_ data: [String: Any]) {
        guard let id = data["id"] as? String,
              let name = data["name"] as? String,
              let stock = data["stock"] as? Int,
              let normalStock = data["normalStock"] as? Int,
              let warningStock = data["warningStock"] as? Int,
              let alertStock = data["alertStock"] as? Int,
              let icon = data["icon"] as? String,
              let color = data["color"] as? String,
              let aisle = data["aisle"] as? String else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.stock = stock
        self.aisle = aisle
        self.normalStock = normalStock
        self.warningStock = warningStock
        self.alertStock = alertStock
        self.icon = icon
        self.color = color
    }
    
    /// Converts the `Medicine` into a dictionary representation.
    ///
    /// Useful when saving a `Medicine` in a database.
    ///
    /// - Returns: A `[String: Any]` dictionary containing the medicine's properties.
    func data() -> [String: Any] {
        let data: [String: Any] = [
            "id": self.id,
            "name": name,
            "stock": stock,
            "aisle": aisle,
            "normalStock": normalStock,
            "warningStock": warningStock,
            "alertStock": alertStock,
            "icon": icon,
            "color": color
        ]
        
        return data
    }
}
