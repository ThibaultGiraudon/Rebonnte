//
//  FirestoreRepository+Aisle.swift
//  MediStock
//
//  Created by Thibault Giraudon on 15/09/2025.
//

import Foundation
import FirebaseFirestore

extension FirestoreRepository {
    
    func fetchAisles(sortedBy sort: SortOption, matching name: String, nextItems: Bool) async throws -> [Aisle] {
        var query: Query = db.collection("aisles").limit(to: pageSize).order(by: sort.value)
        
        if !name.isEmpty {
            query = query.whereField("name", isEqualTo: name)
        }
        
        if nextItems == true, let lastDocument {
            query = query.start(afterDocument: lastDocument)
        }
        
        let snapshot = try await query.getDocuments()
        
        let documents = snapshot.documents
        let items = documents.compactMap {
            Aisle($0.data())
        }
        
        self.lastDocument = documents.last
        
        return items
    }
    
    func fetchAllAisles(matching name: String = "") async throws -> [Aisle] {
        let snapshots = try await db.collection("aisles")/*.whereField("name", isEqualTo: name)*/.getDocuments()
        
        let documents = snapshots.documents
        
        let items = documents.compactMap {
            Aisle($0.data())
        }
        
        return items
    }
    
    func addAisle(_ medicine: Aisle) async throws {
        try await db.collection("aisles").document(medicine.id).setData(medicine.data())
    }
    
    func deleteAisle(_ aisle: [Aisle]) async throws {
        for medicine in aisle {
            try await db.collection("aisles").document(medicine.id).delete()
        }
    }
}
