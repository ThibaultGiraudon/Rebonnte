import Foundation

struct Medicine: Identifiable, Codable, Equatable, Hashable {
    var id = UUID().uuidString
    var name: String
    var stock: Int
    var aisle: String
    var normalStock: Int
    var warningStock: Int
    var alertStock: Int
    var icon: String
    var color: String

    init(id: String = UUID().uuidString, name: String, stock: Int, aisle: String, normalStock: Int, warningStock: Int, alertStock: Int, icon: String, color: String) {
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
