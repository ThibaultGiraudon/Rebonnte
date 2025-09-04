//
//  FirestoreRepositoryFake.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import Foundation
@testable import MediStock

class FirestoreRepositoryFake: FirestoreRepositoryInterface {
    var medicines: [Medicine] = []
    var history: [HistoryEntry] = []
    var user: User?
    var medicineError: Error?
    var historyError: Error?
    var userError: Error?
    
    func fetchMedicines(sortedBy sort: MediStock.SortOption, matching name: String, nextItems: Bool) async throws -> [MediStock.Medicine] {
        if let medicineError {
            throw medicineError
        }
        return medicines
    }
    
    func addMedicine(_ medicine: MediStock.Medicine) async throws {
        if let medicineError {
            throw medicineError
        }
    }
    
    func updateStock(for document: String, amount: Int) async throws {
        if let medicineError {
            throw medicineError
        }
    }
    
    func updateMedicine(_ medicine: MediStock.Medicine) async throws {
        if let medicineError {
            throw medicineError
        }
    }
    
    func deleteMedcines(_ medicines: [MediStock.Medicine]) async throws {
        if let medicineError {
            throw medicineError
        }
    }
    
    func fetchHistory(for medicine: MediStock.Medicine) async throws -> [MediStock.HistoryEntry] {
        if let historyError {
            throw historyError
        }
        return history
    }
    
    func addHistory(_ history: MediStock.HistoryEntry) async throws {
        if let historyError {
            throw historyError
        }
    }
    
    func fetchUser(with uid: String) async throws -> MediStock.User? {
        if let userError {
            throw userError
        }
        return user
    }
    
    func addUser(_ user: MediStock.User) async throws {
        if let userError {
            throw userError
        }
    }
    
    func updateUser(_ user: MediStock.User) async throws {
        if let userError {
            throw userError
        }
    }
}
