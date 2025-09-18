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
    @Published var normalStock: Int?
    @Published var warningStock: Int?
    @Published var alertStock: Int?
    @Published var color: String = "6495ED"
    @Published var icon: String = "pills"
    
    
    @Published var aisles: [String] = []
    
    @Published var error: String? = nil
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    
    var shouldDisabled: Bool {
        guard let stock = stock, let normalStock = normalStock, let warningStock = warningStock, let alertStock = alertStock else { return true }
        return name.isEmpty || aisle.isEmpty || stock < 0 || normalStock < 0 || warningStock < 0 || alertStock < 0 || isLoading == true
    }
    
    private let repository: FirestoreRepositoryInterface
    
    init(repository: FirestoreRepositoryInterface = FirestoreRepository(), aisle: String = "") {
        self.repository = repository
        self.aisle = aisle
    }
    
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
    
    func addMedicine(user: String, tryAnyway: Bool = false) async {
        self.error = nil
        guard let stock = stock, let normalStock = normalStock, let warningStock = warningStock, let alertStock = alertStock else {
            return
        }
        isLoading = true
        let newMedicine = Medicine(name: name, stock: stock, aisle: aisle, normalStock: normalStock, warningStock: warningStock, alertStock: alertStock, icon: icon, color: color)
        do {
            print(" all medicine :\(try await repository.fetchAllMedicines(matching: name))")
            if try await repository.fetchAllMedicines(matching: name).isEmpty || tryAnyway == true {
                try await repository.addMedicine(newMedicine)
                await addHistory(action: "Add new medicine",
                                 user: user,
                                 medicineId: newMedicine.id,
                                 details: "\(user) add \(newMedicine.name) with initial stock of \(stock)",
                                 currentStock: stock)
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
        self.normalStock = nil
        self.warningStock = nil
        self.alertStock = nil
    }
}
