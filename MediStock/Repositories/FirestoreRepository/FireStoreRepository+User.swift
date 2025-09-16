//
//  FireStoreRepository+User.swift
//  MediStock
//
//  Created by Thibault Giraudon on 15/09/2025.
//

import Foundation

extension FirestoreRepository {
    func fetchUser(with uid: String) async throws -> User? {
        let document = try await db.collection("users").document(uid).getDocument()
        return User(document.data())
    }
    
    func addUser(_ user: User) async throws {
        try await db.collection("users").document(user.uid).setData(user.data())
    }
    
    func updateUser(_ user: User) async throws {
        try await db.collection("users").document(user.uid).setData(user.data())
    }
}
