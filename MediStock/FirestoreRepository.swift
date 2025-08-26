//
//  FirestoreRepository.swift
//  MediStock
//
//  Created by Thibault Giraudon on 26/08/2025.
//

import Foundation
import Firebase

class FirestoreRepository {
    private let db = Firestore.firestore()
    
    func fetchMedicines() async throws -> [Medicine] {
        return try await fetch("medicines")
    }
    
    func addMedicine(_ medicine: Medicine) async throws {
        try await db.collection("medicines").document(medicine.id).setData(medicine.data())
    }
    
    func updateStock(for document: String, amount: Int) async throws {
        try await db.collection("medicines").document(document).updateData(["stock": amount])
    }
    
    func updateMedicine(_ medicine: Medicine) async throws {
        try await db.collection("medicines").document(medicine.id).setData(medicine.data())
    }
    
    func deleteMedcines(_ medicines: [Medicine]) async throws {
        for medicine in medicines {
            try await db.collection("medicines").document(medicine.id).delete()
        }
    }
    
    func fetchHistory(for medicine: Medicine) async throws -> [HistoryEntry] {
        print("medicine id: \(medicine.id)")
        let snapshots = db.collection("history").whereField("medicineId", isEqualTo: medicine.id)
        
        let snapshot = try await snapshots.getDocuments()
        let items = snapshot.documents.compactMap {
            try? $0.data(as: HistoryEntry.self)
        }
        
        print("History items: \(items)")
        return items
    }
    
    func addHistory(_ history: HistoryEntry) async throws {
        try await db.collection("history").document(history.id).setData(history.data())
    }
    
    private func fetch<T: Codable>(_ collection: String) async throws -> [T] {
        let snapshot = try await db.collection(collection).getDocuments()
        
        let documents = snapshot.documents
        let items = documents.compactMap {
            try? $0.data(as: T.self)
        }
        
        print("items: \(items)")
        return items
    }
}
