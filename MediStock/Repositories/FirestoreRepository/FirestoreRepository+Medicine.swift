//
//  FirestoreRepository+Medicine.swift
//  MediStock
//
//  Created by Thibault Giraudon on 15/09/2025.
//

import Foundation
import FirebaseFirestore

extension FirestoreRepository {
    
    func fetchMedicines(sortedBy sort: SortOption, matching name: String, nextItems: Bool) async throws -> [Medicine] {
        var query: Query = db.collection("medicines").limit(to: pageSize).order(by: sort.value)
        
        if !name.isEmpty {
            query = query.whereField("name", isEqualTo: name)
        }
        
        if nextItems, let doc = self.lastDocument {
            query = query.start(afterDocument: doc)
        }
        
        let snapshot = try await query.getDocuments()
        
        let documents = snapshot.documents
        let items = documents.compactMap {
            Medicine($0.data())
        }
        
        self.lastDocument = documents.last
        
        return items
    }
    
    func fetchAllMedicines(matching name: String = "") async throws -> [Medicine] {
        let snapshots = try await db.collection("medicines").whereField("name", isEqualTo: name).getDocuments()
        
        let documents = snapshots.documents
        
        let items = documents.compactMap {
            Medicine($0.data())
        }
        
        return items
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
    
    func deleteMedicines(_ medicines: [Medicine]) async throws {
        for medicine in medicines {
            try await db.collection("medicines").document(medicine.id).delete()
        }
    }
}
