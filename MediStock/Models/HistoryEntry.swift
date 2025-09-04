import Foundation
import FirebaseFirestoreSwift

struct HistoryEntry: Identifiable, Codable, Equatable {
    var id = UUID().uuidString
    var medicineId: String
    var user: String
    var action: String
    var details: String
    var timestamp: Date
    var currentStock: Int

    init(id: String = UUID().uuidString, medicineId: String, user: String, action: String, details: String, timestamp: Date = Date(), currentStock: Int) {
        self.id = id
        self.medicineId = medicineId
        self.user = user
        self.action = action
        self.details = details
        self.timestamp = timestamp
        self.currentStock = currentStock
    }
    
    func data() -> [String: Any] {
        let data: [String: Any] = [
            "id": self.id,
            "medicineId": self.medicineId,
            "user": self.user,
            "action": self.action,
            "details": self.details,
            "timestamp": self.timestamp,
            "currentStock": self.currentStock
        ]
        
        return data
    }
    
    static func == (lhs: HistoryEntry, rhs: HistoryEntry) -> Bool {
        lhs.id == rhs.id
    }
    
}
