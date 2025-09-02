import Foundation

@MainActor
class MedicineStockViewModel: ObservableObject {
    @Published var medicines: [Medicine] = []
    var aisles: [String] {
        Array(Set(medicines.map { $0.aisle })).sorted()
    }
    @Published var history: [HistoryEntry] = []
    
    @Published var filterText: String = ""
    @Published var sortOption: SortOption = .none
    
    @Published var error: String? = nil
    
    private let repository: FirestoreRepositoryInterface
    
    init(repository: FirestoreRepositoryInterface = FirestoreRepository()) {
        self.repository = repository
    }

    func fetchMedicines(fetchNext: Bool = false) async {
        self.error = nil
        do {
            let fetchedMedicines = try await repository.fetchMedicines(sortedBy: sortOption, matching: filterText, nextItems: fetchNext)
            if fetchNext == true {
                for medicine in fetchedMedicines {
                    self.medicines.append(medicine)
                }
            } else {
                self.medicines = fetchedMedicines
            }
        } catch {
            self.error = "fetching medicines"
        }
    }

    func deleteMedicines(at offsets: IndexSet) async {
        self.error = nil
        let medicinesToDelete = offsets.map { medicines[$0] }
        do {
            try await repository.deleteMedcines(medicinesToDelete)
        } catch {
            self.error = "deleting medicines"
        }
    }

    func updateMedicine(_ medicine: Medicine, user: String) async {
        self.error = nil
        do {
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
                    details: "\(user) changed stock from \(currentMedicine.stock) to \(medicine.stock)",
                    currentStock: medicine.stock
                )
            }
            
            if currentMedicine.aisle != medicine.aisle {
                await addHistory(
                    action: "Updated \(medicine.name)",
                    user: user,
                    medicineId: medicine.id,
                    details: "\(user) changed aisle from \(currentMedicine.aisle) to \(medicine.aisle)",
                    currentStock: medicine.stock
                )
            }
            
            if currentMedicine.name != medicine.name {
                await addHistory(
                    action: "Updated \(medicine.name)",
                    user: user,
                    medicineId: medicine.id,
                    details: "\(user) changed name from \(currentMedicine.name) to \(medicine.name)",
                    currentStock: medicine.stock
                )
            }

            self.medicines[index] = medicine
        } catch {
            self.error = "updating medicines"
        }
    }

    private func addHistory(action: String, user: String, medicineId: String, details: String, currentStock: Int) async {
        self.error = nil
        let history = HistoryEntry(medicineId: medicineId, user: user, action: action, details: details, currentStock: currentStock)
        do {
            try await repository.addHistory(history)
            self.history.append(history)
            self.history.sort(by: { $0.timestamp > $1.timestamp })
        } catch {
            self.error = "adding change to history"
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
