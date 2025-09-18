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
    var user: User? = nil
    var aisles: [Aisle] = []
    var medicineError: Error?
    var historyError: Error?
    var userError: Error?
    var aisleError: Error?
    var aisleUpdateError: Error?
    
    func fetchMedicines(sortedBy sort: MediStock.SortOption, matching name: String, nextItems: Bool) async throws -> [MediStock.Medicine] {
        if let medicineError {
            throw medicineError
        }
        return medicines
    }
    
    func fetchAllMedicines(matching name: String) async throws -> [MediStock.Medicine] {
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
    
    func deleteMedicines(_ medicines: [MediStock.Medicine]) async throws {
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
    
    func deleteHistory(_ history: [MediStock.HistoryEntry]) async throws {
        if let historyError {
            throw historyError
        }
    }
    
    func fetchAllAisles(matching name: String) async throws -> [MediStock.Aisle] {
        if let aisleError {
            throw aisleError
        }
        return aisles
    }
    
    func addAisle(_ medicine: MediStock.Aisle) async throws {
        if let aisleError {
            throw aisleError
        }
    }
    
    func updateAisle(_ aisle: MediStock.Aisle) async throws {
        if let aisleUpdateError {
            throw aisleUpdateError
        }
    }
}
