//
//  AddAisleViewModel.swift
//  MediStock
//
//  Created by Thibault Giraudon on 16/09/2025.
//

import Foundation

/// View model responsible for managing the state and logic when adding a new aisle.
///
/// `AddAisleViewModel` handles user input, validates the data, and communicates
/// with the repository to persist the aisle. 
class AddAisleViewModel: ObservableObject {
    
    /// The aisle name entered by the user.
    @Published var name: String = ""
    
    /// The icon selected for the aisle.
    @Published var icon: String = "pills.fill"
    
    /// The color associated with the aisle's icon.
    @Published var color: String = "6495ED"

    /// An optional error message if the aisle creation fails.
    @Published var error: String?
    
    /// Indicates whether the aisle creation process is currently running.
    @Published var isLoading: Bool = false
    
    /// The repository used to persist data in Firestore.
    private let repository: FirestoreRepositoryInterface
    
    /// Initializes a new `AddAisleViewModel`.
    ///
    /// - Parameter repository: The repository used for Firestore operations.
    ///   Defaults to an instance of `FirestoreRepository`.
    init(repository: FirestoreRepositoryInterface = FirestoreRepository()) {
        self.repository = repository
    }
    
    /// Creates a new aisle and saves it in Firestore.
    ///
    /// This method attempts to persist a new `Aisle` using the provided user input.
    /// If the operation fails, an error message is stored.
    @MainActor
    func addAisle() async {
        self.error = nil
        self.isLoading = true
        defer {
            self.restetFields()
            self.isLoading = false
        }
        do {
            let newAisle = Aisle(name: name, icon: icon, color: color)
            try await repository.addAisle(newAisle)
        } catch {
            self.error = "creating aisle"
        }
    }
    
    /// Resets all user input fields to their default values.
    private func restetFields() {
        self.name = ""
        self.icon = "pills.fill"
        self.color = "6495ED"
    }
}
