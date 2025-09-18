//
//  FirestoreRepositoryProtocol.swift
//  MediStock
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import Foundation

/// Interface for accessing and modifying data in Firestore
/// This protocol allows injection of real or mock repository for testing.
protocol FirestoreRepositoryInterface {
    
    // MARK: - Medicine
    
    /// Fetches medicines from Firestore with optionnal sort and filter options.
    /// Fetches medicines 20 by 20 for performance.
    ///
    /// - Parameters:
    ///   - sort: Option to sort the results.
    ///   - name: A `String` to filter the medicine by name.
    ///   - nextItem: If true, fetch next page of results.
    /// - Returns: An Array of `Medicine` matching the sort and filter options.
    /// - Throws: An `Error` if the operation fails.
    func fetchMedicines(sortedBy sort: SortOption, matching name: String, nextItems: Bool) async throws -> [Medicine]
    
    /// Fetches all medicines from Firestore matching the given name.
    ///
    /// - Parameter name: A `String` representing the medicines name to fetch.
    /// - Returns: An  Array of  `Medicine` matching the given name.
    /// - Throws: An `Error` if the operation fails.
    func fetchAllMedicines(matching name: String) async throws -> [Medicine]
    
    /// Adds a new `Medicine` in Firestore
    ///
    /// - Parameter medicine: The `Medicine` to save.
    /// - Throws: An `Error` if the operation fails.
    func addMedicine(_ medicine: Medicine) async throws
    
    /// Updates the stock of a given medicine.
    ///
    /// - Parameters:
    ///   - document: The medicine `UID` to update.
    ///   - amount: An `Int` representing the stock level to save.
    /// - Throws: An `Error` if the operation fails.
    func updateStock(for document: String, amount: Int) async throws
    
    /// Updates the given medicine in Firestore
    ///
    /// - Parameter medicine: The medicine to save.
    /// - Throws: An `Error` if the operation fails.
    func updateMedicine(_ medicine: Medicine) async throws
    
    /// Deletes the given medicines from Firestore
    ///
    /// - Parameter medicine: The medicine to delete
    /// - Throws: An `Error` if the operation fails.
    func deleteMedicines(_ medicines: [Medicine]) async throws
    
    // MARK: - History
    
    /// Fetches all history entry for a given medicine.
    ///
    /// - Parameter medicine: The medicine from which fetching history.
    /// - Returns: An Array of `HistoryEntry`.
    /// - Throws: An `Error` if the operation fails.
    func fetchHistory(for medicine: Medicine) async throws -> [HistoryEntry]
    
    /// Deletes all given entry in Firestore.
    ///
    /// - Parameter history: An Array of `HistoryEntry` to delete.
    /// - Throws: An `Error` if the operation fails.
    func deleteHistory(_ history: [HistoryEntry]) async throws
    
    /// Adds a new history entry in Firestore
    ///
    /// - Parameter history: The `HistoryEntry` to save.
    /// - Throws: An `Error` if the operation fails.
    func addHistory(_ history: HistoryEntry) async throws
    
    // MARK: - User
    
    /// Fetches the user associated with the given uid.
    ///
    /// - Parameter uid: The unique ID of the user.
    /// - Returns: An optionnal `User` if the fetch succeed, otherwise `Nil`.
    /// - Throws: An `Error` if the operation fails.
    func fetchUser(with uid: String) async throws -> User?
    
    /// Adds a new user to Firebase.
    ///
    /// - Parameter user: The user to save.
    /// - Throws: An `Error` if the operation fails.
    func addUser(_ user: User) async throws
    
    /// Updates a user in Firebase.
    ///
    /// - Parameter user: The user to update.
    /// - Throws: An `Error` if the operation fails.
    func updateUser(_ user: User) async throws
    
    // MARK: - Aisle
    
    /// Fetches all aisles matching a given name.
    ///
    /// - Parameter name: A `String` representing the name of aisles.
    /// - Returns: An Array of `Aisle` matching the given name.
    /// - Throws: An `Error` if the operation fails.
    func fetchAllAisles(matching name: String) async throws -> [Aisle]
    
    /// Adds an aisle in Firestore.
    ///
    /// - Parameter medicine: The medicine to add.
    /// - Throws: An `Error` if the operation fails.
    func addAisle(_ medicine: Aisle) async throws
    
    /// Updates an aisle from Firestore.
    ///
    /// - Parameter aisle: The aisle to update.
    /// - Throws: An `Error` if the operation fails.
    func updateAisle(_ aisle: Aisle) async throws
}
