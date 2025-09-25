//
//  AisleViewModel.swift
//  MediStock
//
//  Created by Thibault Giraudon on 15/09/2025.
//

import Foundation

/// View model responsible for managing aisles and their medicines.
///
/// `AislesViewModel` handles fetching, filtering, and updating aisles.
/// It communicates with the repository to persist changes.
class AislesViewModel: ObservableObject {
    
    /// The list of aisles available in the repository.
    @Published var aisles: [Aisle] = []
    
    /// The text used to filter aisles by name.
    @Published var filterText: String = ""
    
    /// A computed list of aisles filtered by `filterText`.
    var filteredAisles: [Aisle] {
        aisles.filter { filterText.isEmpty || $0.name.lowercased().contains(filterText.lowercased()) }
    }
    
    /// An optional error message if an operation fails.
    @Published var error: String?
    
    /// Indicates whether a repository operation is currently running.
    @Published var isLoading: Bool = false
    
    /// The repository used to fetch and update aisles.
    private let repository: FirestoreRepositoryInterface
    
    /// Initializes a new `AislesViewModel`.
    ///
    /// - Parameter repository: The repository used for Firestore operations (default is `FirestoreRepository`).
    init(repository: FirestoreRepositoryInterface = FirestoreRepository()) {
        self.repository = repository
    }
    
    /// Fetches all aisles from the repository and updates the local list.
    @MainActor
    func fetchAisles() async {
        self.error = nil
        
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            self.aisles = try await repository.fetchAllAisles(matching: "")
        } catch {
            self.error = "fetching aisles"
        }
    }
    
    /// Adds a medicine to a given aisle and updates the repository.
    ///
    /// - Parameters:
    ///   - medicine: The medicine to add.
    ///   - aisleName: The name of the aisle where the medicine should be added.
    func add(_ medicine: Medicine, in aisleName: String) async {
        self.error = nil
        
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            await self.fetchAisles()
            guard let index = self.aisles.firstIndex(where: { $0.name == aisleName }) else {
                self.error = "adding medicine to aisle"
                return
            }
            var aisle = self.aisles[index]
            aisle.medicines.append(medicine.id)
            try await repository.updateAisle(aisle)
            self.aisles[index] = aisle
        } catch {
            self.error = "adding medicine to aisle"
        }
    }
    
    /// Removes a medicine from a given aisle and updates the repository.
    ///
    /// - Parameters:
    ///   - medicine: The medicine to remove.
    ///   - aisleName: The name of the aisle from which the medicine should be removed.
    func remove(_ medicine: Medicine, from aisleName: String) async {
        self.error = nil
        
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            await self.fetchAisles()
            guard let index = self.aisles.firstIndex(where: { $0.name == aisleName }) else {
                self.error = "removing medicine from aisle"
                return
            }
            var aisle = self.aisles[index]
            aisle.medicines.removeAll { $0 == medicine.id }
            try await repository.updateAisle(aisle)
            self.aisles[index] = aisle
        } catch {
            self.error = "removing medicine from aisle"
        }
    }
}

