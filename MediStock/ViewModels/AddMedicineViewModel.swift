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
    
    func addMedicine() async {
        guard let stock = stock else {
            return
        }
        let newMedicine = Medicine(name: name, stock: stock, aisle: aisle)
        do {
            try await repository.addMedicine(newMedicine)
        } catch {
            print("An error occured while adding medicine: \(error)")
        }
    }
}
