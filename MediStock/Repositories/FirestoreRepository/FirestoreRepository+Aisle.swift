//
//  FirestoreRepository+Aisle.swift
//  MediStock
//
//  Created by Thibault Giraudon on 15/09/2025.
//

import Foundation
import FirebaseFirestore

extension FirestoreRepository {
    
    func fetchAllAisles(matching name: String = "") async throws -> [Aisle] {
        var query: Query = db.collection("aisles")
        
        if !name.isEmpty {
            query = query.whereField("name", isEqualTo: name)
        }
        
        let snapshot = try await query.getDocuments()
        
        let documents = snapshot.documents
        let items = documents.compactMap {
            Aisle($0.data())
        }
        
        return items
    }
    
    func updateAisle(_ aisle: Aisle) async throws {
        try await db.collection("aisles").document(aisle.id).setData(aisle.data())
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
