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

    func increaseStock(_ medicine: Medicine, user: String) async {
        await updateStock(medicine, by: 1, user: user)
    }

    func decreaseStock(_ medicine: Medicine, user: String) async {
        await updateStock(medicine, by: -1, user: user)
    }

    private func updateStock(_ medicine: Medicine, by amount: Int, user: String) async {
        let newStock = medicine.stock + amount
        do {
            try await repository.updateStock(for: medicine.id, amount: newStock)
            
            if let index = self.medicines.firstIndex(where: { $0.id == medicine.id }) {
                self.medicines[index].stock = newStock
            }
            
            await self.addHistory(
                action: "\(amount > 0 ? "Increased" : "Decreased") stock of \(medicine.name) by \(amount)",
                user: user,
                medicineId: medicine.id,
                details: "Stock changed from \(medicine.stock - amount) to \(newStock)"
            )
        } catch {
            print("Failed to update stock: \(error)")
        }
    }

    func updateMedicine(_ medicine: Medicine, user: String) async {
        do {
            try await repository.updateMedicine(medicine)
            
            await addHistory(action: "Updated \(medicine.name)", user: user, medicineId: medicine.id, details: "Updated medicine details")
            if let index = self.medicines.firstIndex(where: { $0.id == medicine.id }) {
                self.medicines[index] = medicine
            }
        } catch let error {
            print("Error updating document: \(error)")
        }
    }

    private func addHistory(action: String, user: String, medicineId: String, details: String) async {
        let history = HistoryEntry(medicineId: medicineId, user: user, action: action, details: details)
        do {
            try await repository.addHistory(history)
        } catch let error {
            print("Error adding history: \(error)")
        }
    }

    func fetchHistory(for medicine: Medicine) async {
        do {
            self.history = try await repository.fetchHistory(for: medicine)
        } catch {
            print("Failed to fetch history: \(error)")
        }
    }
}
