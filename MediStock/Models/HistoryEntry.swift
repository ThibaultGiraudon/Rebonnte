import Foundation

/// A record representing an action performed on a medicine entry in the stock history.
///
/// `HistoryEntry` stores information about who performed the action, what kind of action
/// was taken, and the stock level at the time of the event.
struct HistoryEntry: Identifiable, Codable, Equatable {
    
    /// The unique identifier for the history entry.
    var id = UUID().uuidString
    
    /// The identifier of the medicine concerned by this entry.
    var medicineId: String
    
    /// The user who performed the action (e.g., pharmacist, admin).
    var user: String
    
    /// The type of action performed (e.g., "Added", "Removed", "Edited").
    var action: String
    
    /// Additional details about the action.
    var details: String
    
    /// The date and time when the action occurred.
    var timestamp: Date
    
    /// The current stock of the medicine after the action.
    var currentStock: Int

    /// Initializes a new `HistoryEntry`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the entry (default is a new UUID).
    ///   - medicineId: The identifier of the associated medicine.
    ///   - user: The user who performed the action.
    ///   - action: The type of action performed.
    ///   - details: A descriptive message providing context about the action.
    ///   - timestamp: The date and time of the action (default is `Date()`).
    ///   - currentStock: The resulting stock after the action.
    init(
        id: String = UUID().uuidString,
        medicineId: String,
        user: String,
        action: String,
        details: String,
        timestamp: Date = Date(),
        currentStock: Int
    ) {
        self.id = id
        self.medicineId = medicineId
        self.user = user
        self.action = action
        self.details = details
        self.timestamp = timestamp
        self.currentStock = currentStock
    }
    
    /// Converts the `HistoryEntry` into a dictionary representation.
    ///
    /// Useful when saving the entry in a database.
    ///
    /// - Returns: A `[String: Any]` dictionary containing all the entry properties.
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
    
    /// Compares two history entries for equality based on their `id`.
    static func == (lhs: HistoryEntry, rhs: HistoryEntry) -> Bool {
        lhs.id == rhs.id
    }
}
