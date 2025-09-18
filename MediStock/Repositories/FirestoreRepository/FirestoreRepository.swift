//
//  FirestoreRepository.swift
//  MediStock
//
//  Created by Thibault Giraudon on 26/08/2025.
//

import Foundation
import Firebase

class FirestoreRepository: FirestoreRepositoryInterface {
    let db = Firestore.firestore()
    var lastDocument: DocumentSnapshot?
    var pageSize = 200
    
    func fetchHistory(for medicine: Medicine) async throws -> [HistoryEntry] {
        let snapshots = db.collection("history").whereField("medicineId", isEqualTo: medicine.id)
        let snapshot = try await snapshots.getDocuments()
        
        let items: [HistoryEntry] = snapshot.documents.compactMap { doc in
            let data = doc.data()
            
            guard let id = data["id"] as? String else { return nil }
            guard let medicineId = data["medicineId"] as? String else { return nil }
            guard let user = data["user"] as? String else { return nil }
            guard let action = data["action"] as? String else { return nil }
            guard let details = data["details"] as? String else { return nil }
            guard let timestampValue = data["timestamp"] as? Timestamp else { return nil }
            guard let currentStock = data["currentStock"] as? Int else { return nil }
            
            let timestamp = timestampValue.dateValue()
            
            return HistoryEntry(
                id: id,
                medicineId: medicineId,
                user: user,
                action: action,
                details: details,
                timestamp: timestamp,
                currentStock: currentStock
            )
        }
        
        return items
    }
    
    func deleteHistory(_ history: [HistoryEntry]) async throws {
        for item in history {
            try await db.collection("history").document(item.id).delete()
        }
    }
    
    func addHistory(_ history: HistoryEntry) async throws {
        try await db.collection("history").document(history.id).setData(history.data())
    }
}
