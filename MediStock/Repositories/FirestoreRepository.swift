//
//  FirestoreRepository.swift
//  MediStock
//
//  Created by Thibault Giraudon on 26/08/2025.
//

import Foundation
import Firebase

class FirestoreRepository: FirestoreRepositoryInterface {
    private let db = Firestore.firestore()
    private var lastDocument: DocumentSnapshot?
    private let pageSize = 20
    
    func fetchMedicines(sortedBy sort: SortOption, matching name: String, nextItems: Bool) async throws -> [Medicine] {
        var query: Query = db.collection("medicines").limit(to: pageSize).order(by: sort.value)
        
        if !name.isEmpty {
            query = query.whereField("name", isEqualTo: name)
        }
        
        if nextItems == true, let lastDocument {
            query = query.start(afterDocument: lastDocument)
        }
        
        let snapshot = try await query.getDocuments()
        
        let documents = snapshot.documents
        let items = documents.compactMap {
            try? $0.data(as: Medicine.self)
        }
        
        self.lastDocument = documents.last
        
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
    
    func deleteMedcines(_ medicines: [Medicine]) async throws {
        for medicine in medicines {
            try await db.collection("medicines").document(medicine.id).delete()
        }
    }
    
    func fetchHistory(for medicine: Medicine) async throws -> [HistoryEntry] {
        let snapshots = db.collection("history").whereField("medicineId", isEqualTo: medicine.id)
        
        let snapshot = try await snapshots.getDocuments()
        let items = snapshot.documents.compactMap {
            try? $0.data(as: HistoryEntry.self)
        }
        
        return items
    }
    
    func addHistory(_ history: HistoryEntry) async throws {
        try await db.collection("history").document(history.id).setData(history.data())
    }
    
    func fetchUser(with uid: String) async throws -> User? {
        let document = try await db.collection("users").document(uid).getDocument()
        return User(document.data(), id: document.documentID)
    }
    
    func addUser(_ user: User) async throws {
        try await db.collection("users").document(user.uid).setData(user.data())
    }
    
    func updateUser(_ user: User) async throws {
        try await db.collection("users").document(user.uid).setData(user.data())
    }
}
