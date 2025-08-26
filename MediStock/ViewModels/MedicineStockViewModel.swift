import Foundation

@MainActor
class MedicineStockViewModel: ObservableObject {
    @Published var medicines: [Medicine] = []
    var aisles: [String] {
        medicines.map {
            $0.aisle
        }.sorted()
    }
    @Published var history: [HistoryEntry] = []
    private let repository = FirestoreRepository()

    func fetchMedicines() async {
        do {
            self.medicines = try await repository.fetchMedicines()
        } catch {
            print("Failed to fetch medicines: \(error)")
        }
    }

    func addRandomMedicine(user: String) async {
        let medicine = Medicine(name: "Medicine \(Int.random(in: 1...100))", stock: Int.random(in: 1...100), aisle: "Aisle \(Int.random(in: 1...10))")
        do {
            try await repository.addMedicine(medicine)
             await addHistory(action: "Added \(medicine.name)", user: user, medicineId: medicine.id, details: "Added new medicine")
        } catch let error {
            print("Error adding document: \(error)")
        }
    }

    func deleteMedicines(at offsets: IndexSet) async {
        let medicinesToDelete = offsets.map { medicines[$0] }
        do {
            try await repository.deleteMedcines(medicinesToDelete)
        } catch {
            print("Failed to delete medicines: \(error)")
        }
    }

    func updateMedicine(_ medicine: Medicine, user: String) async {
        do {
            
            print(medicine.id)
            print(medicines)
            
            guard let index = self.medicines.firstIndex(where: { $0.id == medicine.id }) else {
                print("Failed to retrieve medicine")
                return
            }
            
            try await repository.updateMedicine(medicine)

            let currentMedicine = self.medicines[index]
            let amount = medicine.stock - currentMedicine.stock
            if amount != 0 {
                await self.addHistory(
                    action: "\(amount > 0 ? "Increased" : "Decreased") stock of \(medicine.name) by \(amount)",
                    user: user,
                    medicineId: medicine.id,
                    details: "Stock changed from \(currentMedicine.stock) to \(medicine.stock)"
                )
            }
            
            if currentMedicine.aisle != medicine.aisle {
                await addHistory(action: "Updated \(medicine.name)", user: user, medicineId: medicine.id, details: "Changed aisle from \(currentMedicine.aisle) to \(medicine.aisle)")
            }
            
            if currentMedicine.name != medicine.name {
                await addHistory(action: "Updated \(medicine.name)", user: user, medicineId: medicine.id, details: "Changed name from \(currentMedicine.name) to \(medicine.name)")
            }

            self.medicines[index] = medicine
        } catch {
            print("Error updating document: \(error)")
        }
    }

    private func addHistory(action: String, user: String, medicineId: String, details: String) async {
        let history = HistoryEntry(medicineId: medicineId, user: user, action: action, details: details)
        do {
            try await repository.addHistory(history)
            self.history.append(history)
            self.history.sort(by: { $0.timestamp > $1.timestamp })
        } catch {
            print("Error adding history: \(error)")
        }
    }

    func fetchHistory(for medicine: Medicine) async {
        do {
            self.history = try await repository.fetchHistory(for: medicine).sorted(by: { $0.timestamp > $1.timestamp})
        } catch {
            print("Failed to fetch history: \(error)")
        }
    }
}
