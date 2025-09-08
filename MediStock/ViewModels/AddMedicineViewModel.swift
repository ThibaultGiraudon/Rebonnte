//
//  AddMedicineViewModel.swift
//  MediStock
//
//  Created by Thibault Giraudon on 26/08/2025.
//

import Foundation

@MainActor
class AddMedicineViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var aisle: String = ""
    @Published var stock: Int?
    
    @Published var error: String? = nil
    @Published var showAlert: Bool = false
    
    var shouldDisabled: Bool {
        guard let stock = stock else { return true }
        return name.isEmpty || aisle.isEmpty || stock < 0
    }
    
    private let repository: FirestoreRepositoryInterface
    
    init(repository: FirestoreRepositoryInterface = FirestoreRepository()) {
        self.repository = repository
    }
    
    func addMedicine(user: String, tryAnyway: Bool = false) async {
        self.error = nil
        guard let stock = stock else {
            return
        }
        let newMedicine = Medicine(name: name, stock: stock, aisle: aisle)
        do {
            if try await repository.fetchAllMedicines(matching: name).isEmpty || tryAnyway == true {
                try await repository.addMedicine(newMedicine)
                await addHistory(action: "Add new medicine",
                                 user: user,
                                 medicineId: newMedicine.id,
                                 details: "\(user) add \(newMedicine.name) with initial stock of \(stock)",
                                 currentStock: stock)
                self.resetFields()
            } else {
                showAlert = true
            }
        } catch {
            self.error = "adding new medicines"
        }
    }
    
    private func addHistory(action: String, user: String, medicineId: String, details: String, currentStock: Int) async {
        self.error = nil
        let history = HistoryEntry(medicineId: medicineId, user: user, action: action, details: details, currentStock: currentStock)
        do {
            try await repository.addHistory(history)
        } catch {
            self.error = "adding change to history"
        }
    }
    
    private func resetFields() {
        self.name = ""
        self.aisle = ""
        self.stock = nil
    }
}
