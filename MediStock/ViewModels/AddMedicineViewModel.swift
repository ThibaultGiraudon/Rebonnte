//
//  AddMedicineViewModel.swift
//  MediStock
//
//  Created by Thibault Giraudon on 26/08/2025.
//

import Foundation

class AddMedicineViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var aisle: String = ""
    @Published var stock: Int?
    
    var shouldDisabled: Bool {
        guard let stock = stock else { return false }
        return name.isEmpty || aisle.isEmpty || stock < 0
    }
    
    private let repository = FirestoreRepository()
    
    func addMedicine(user: String) async {
        guard let stock = stock else {
            return
        }
        let newMedicine = Medicine(name: name, stock: stock, aisle: aisle)
        do {
            try await repository.addMedicine(newMedicine)
            await addHistory(action: "Add new medicine",
                                 user: user,
                                 medicineId: newMedicine.id,
                                 details: "\(user) add new medicine: \(newMedicine.name) with initial stock of \(stock)",
                                 currentStock: stock)
        } catch {
            print("An error occured while adding medicine: \(error)")
        }
    }
    
    private func addHistory(action: String, user: String, medicineId: String, details: String, currentStock: Int) async {
        let history = HistoryEntry(medicineId: medicineId, user: user, action: action, details: details, currentStock: currentStock)
        do {
            try await repository.addHistory(history)
        } catch {
            print("Error adding history: \(error)")
        }
    }
}
