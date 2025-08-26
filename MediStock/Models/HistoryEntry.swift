import Foundation
import FirebaseFirestoreSwift

struct HistoryEntry: Identifiable, Codable {
    var id = UUID().uuidString
    var medicineId: String
    var user: String
    var action: String
    var details: String
    var timestamp: Date

    init(medicineId: String, user: String, action: String, details: String, timestamp: Date = Date()) {
        self.medicineId = medicineId
        self.user = user
        self.action = action
        self.details = details
        self.timestamp = timestamp
    }
    
    func data() -> [String: Any] {
        let data: [String: Any] = [
            "id": self.id,
            "medicineId": self.medicineId,
            "user": self.user,
            "action": self.action,
            "details": self.details,
            "timestamp": self.timestamp
        ]
        
        return data
    }
}
