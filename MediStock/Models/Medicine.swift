import Foundation

struct Medicine: Identifiable, Codable, Equatable, Hashable {
    var id = UUID().uuidString
    var name: String
    var stock: Int
    var aisle: String

    init(id: String = UUID().uuidString, name: String, stock: Int, aisle: String) {
        self.id = id
        self.name = name
        self.stock = stock
        self.aisle = aisle
    }
    
    init?(_ data: [String: Any]) {
        guard let id = data["id"] as? String,
              let name = data["name"] as? String,
              let stock = data["stock"] as? Int,
              let aisle = data["aisle"] as? String else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.stock = stock
        self.aisle = aisle
    }
    
    func data() -> [String: Any] {
        let data: [String: Any] = [
            "id": self.id,
            "name": name,
            "stock": stock,
            "aisle": aisle
        ]
        
        return data
    }
}
