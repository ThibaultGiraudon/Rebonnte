//
//  FirestoreRepositoryProtocol.swift
//  MediStock
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import Foundation

protocol FirestoreRepositoryInterface {
    func fetchMedicines(sortedBy sort: SortOption, matching name: String, nextItems: Bool) async throws -> [Medicine]
    func fetchAllMedicines(matching name: String) async throws -> [Medicine]
    func addMedicine(_ medicine: Medicine) async throws
    func updateStock(for document: String, amount: Int) async throws
    func updateMedicine(_ medicine: Medicine) async throws
    func deleteMedcines(_ medicines: [Medicine]) async throws
    
    func fetchHistory(for medicine: Medicine) async throws -> [HistoryEntry]
    func addHistory(_ history: HistoryEntry) async throws
    
    func fetchUser(with uid: String) async throws -> User?
    func addUser(_ user: User) async throws
    func updateUser(_ user: User) async throws
    
    func fetchAisles(sortedBy sort: SortOption, matching name: String, nextItems: Bool) async throws -> [Aisle]
    func fetchAllAisles(matching name: String) async throws -> [Aisle]
    func addAisle(_ medicine: Aisle) async throws
    func deleteAisle(_ Aisles: [Aisle]) async throws
}
