//
//  AddMedicineViewModel.swift
//  MediStock
//
//  Created by Thibault Giraudon on 26/08/2025.
//

import Foundation

/// View model responsible for managing the state and logic when adding a new medicine.
///
/// `AddMedicineViewModel` handles user input, validates stock values, fetches available aisles,
/// and communicates with the repository to persist the medicine.
@MainActor
class AddMedicineViewModel: ObservableObject {
    
    /// The name of the medicine.
    @Published var name: String = ""
    
    /// The identifier of the aisle where the medicine is stored.
    @Published var aisle: String = ""
    
    /// The initial stock quantity.
    @Published var stock: Int?
    
    /// The expected normal stock level.
    @Published var normalStock: Int?
    
    /// The threshold that triggers a stock warning.
    @Published var warningStock: Int?
    
    /// The threshold that triggers a stock alert.
    @Published var alertStock: Int?
    
    /// The color associated with the medicine's icon.
    @Published var color: String = "6495ED"
    
    /// The symbol representing the medicine.
    @Published var icon: String = "pills"
    
    /// The list of available aisles fetched from the repository.
    @Published var aisles: [String] = []
    
    /// An optional error message if an operation fails.
    @Published var error: String? = nil
    
    /// Indicates whether an alert should be shown to the user.
    @Published var showAlert: Bool = false
    
    /// Indicates whether a repository operation is currently running.
    @Published var isLoading: Bool = false
    
    /// A flag used to disable the "Add" button when input is invalid or a process is running.
    var shouldDisabled: Bool {
        guard let stock = stock,
              let normalStock = normalStock,
              let warningStock = warningStock,
              let alertStock = alertStock else { return true }
        return name.isEmpty
            || aisle.isEmpty
            || stock < 0
            || normalStock < 0
            || warningStock < 0
            || alertStock < 0
            || isLoading == true
    }
    
    /// The repository used to fetch and persist data.
    private let repository: FirestoreRepositoryInterface
    
    /// Initializes a new `AddMedicineViewModel`.
    ///
    /// - Parameters:
    ///   - repository: The repository used for Firestore operations (default is `FirestoreRepository`).
    ///   - aisle: The preselected aisle identifier (default is an empty string).
    init(repository: FirestoreRepositoryInterface = FirestoreRepository(), aisle: String = "") {
        self.repository = repository
        self.aisle = aisle
    }
    
    /// Fetches all aisles from the repository and sets the first as the default if no aisle is selected.
    func fetchAisles() async {
        self.error = nil
        do {
            aisles = try await repository.fetchAllAisles(matching: "").compactMap { $0.name }
            guard aisle.isEmpty, let firstAisle = aisles.first else { return }
            aisle = firstAisle
        } catch {
            self.error = "fetching aisle list"
        }
    }
    
    /// Creates a new medicine and sends it in the repository.
    ///
    /// If a medicine with the same name already exists, an alert is displayed unless `tryAnyway` is set to true.
    /// A history entry is also recorded, and the medicine is added to the aisle view model.
    ///
    /// - Parameters:
    ///   - user: The user performing the action.
    ///   - tryAnyway: Whether to force adding the medicine even if a duplicate exists (default is `false`).
    func addMedicine(user: String, tryAnyway: Bool = false) async {
        self.error = nil
        guard let stock = stock,
              let normalStock = normalStock,
              let warningStock = warningStock,
              let alertStock = alertStock else {
            return
        }
        isLoading = true
        let newMedicine = Medicine(
            name: name,
            stock: stock,
            aisle: aisle,
            normalStock: normalStock,
            warningStock: warningStock,
            alertStock: alertStock,
            icon: icon,
            color: color
        )
        do {
            if try await repository.fetchAllMedicines(matching: name).isEmpty || tryAnyway == true {
                try await repository.addMedicine(newMedicine)
                let action = "Created \(name) with initial stock of \(stock)"
                
                await addHistory(
                    action: action,
                    user: user,
                    medicineId: newMedicine.id,
                    details: "\(user) \(action)",
                    currentStock: stock
                )
                await AislesViewModel().add(newMedicine, in: newMedicine.aisle)
                self.resetFields()
            } else {
                showAlert = true
            }
        } catch {
            self.error = "adding new medicines"
        }
        isLoading = false
    }
    
    /// Adds a history entry to track the creation of a medicine.
    ///
    /// - Parameters:
    ///   - action: The type of action performed.
    ///   - user: The user who performed the action.
    ///   - medicineId: The identifier of the medicine concerned.
    ///   - details: Additional details about the action.
    ///   - currentStock: The stock level after the action.
    private func addHistory(action: String, user: String, medicineId: String, details: String, currentStock: Int) async {
        self.error = nil
        let history = HistoryEntry(
            medicineId: medicineId,
            user: user,
            action: action,
            details: details,
            currentStock: currentStock
        )
        do {
            try await repository.addHistory(history)
        } catch {
            self.error = "adding change to history"
        }
    }
    
    /// Resets all user input fields to their default values.
    private func resetFields() {
        self.name = ""
        self.aisle = ""
        self.stock = nil
        self.normalStock = nil
        self.warningStock = nil
        self.alertStock = nil
    }
}
