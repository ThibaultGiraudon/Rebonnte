import Foundation

@MainActor
class MedicineStockViewModel: ObservableObject {
    @Published var medicines: [Medicine] = []
    var aisles: [String] = []
    @Published var history: [HistoryEntry] = []
    
    @Published var filterText: String = ""
    @Published var sortOption: SortOption = .none
    @Published var sortAscending: Bool = true
    
    @Published var error: String? = nil
    @Published var isLoading: Bool = false
    
    var filteredMedicines: [Medicine] {
        medicines.filter {
            filterText.isEmpty || $0.name.lowercased().contains(filterText.lowercased())
        }.sorted {
            switch sortOption {
            case .none:
                return sortAscending ? false : true
            case .name:
                return sortAscending ? $0.name < $1.name : $0.name > $1.name
            case .stock:
                return sortAscending ? $0.stock < $1.stock : $0.stock > $1.stock
            }
        }
    }
    var warningMedicines: [Medicine] { medicines.filter { $0.stock <= $0.warningStock && $0.stock > $0.alertStock } }
    var alertMedicines: [Medicine] { medicines.filter { $0.stock <= $0.alertStock } }
    
    private let repository: FirestoreRepositoryInterface
    
    init(repository: FirestoreRepositoryInterface = FirestoreRepository()) {
        self.repository = repository
    }

    func fetchMedicines(fetchNext: Bool = false) async {
        self.error = nil
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchedMedicines = try await repository.fetchMedicines(sortedBy: sortOption, matching: filterText, nextItems: fetchNext)
            if fetchNext == true {
                for medicine in fetchedMedicines {
                    if !self.medicines.contains(where: { $0.id == medicine.id }) {
                        self.medicines.append(medicine)
                    }
                }
            } else {
                self.medicines = fetchedMedicines
            }
        } catch {
            self.error = "fetching medicines"
        }
    }
    
    func medicines(inAisle aisle: String) -> [Medicine] {
        self.medicines.filter { $0.aisle == aisle }
    }

    func deleteMedicines(at offsets: IndexSet) async {
        self.error = nil
        isLoading = true
        let medicinesToDelete = offsets.map {
            medicines[$0]
        }
        do {
            try await repository.deleteMedcines(medicinesToDelete)
            await fetchMedicines()
        } catch {
            self.error = "deleting medicines"
        }
        isLoading = false
    }
    
    func updateStock(for medicine: Medicine, by user: String, _ stock: Int) async {
    func increaseStock(for medicine: Medicine, by user: String, _ amount: Int) async {
        await updateStock(for: medicine, to: medicine.stock + amount, by: user)
    }

    func decreaseStock(for medicine: Medicine, by user: String, _ amount: Int) async {
        await updateStock(for: medicine, to: medicine.stock - amount, by: user)
    }
    
    func updateStock(for medicine: Medicine, to newStock: Int, by user: String) async {
        self.error = nil
        
        guard let index = self.medicines.firstIndex(where: { $0.id == medicine.id }) else {
            self.error = "updating stock"
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let currentMedicine = self.medicines[index]
        do {
            await self.updateHistory(oldMedicine: currentMedicine, newStock: newStock, user: user)
            
            try await repository.updateStock(for: medicine.id, amount: newStock)
            
            medicines[index].stock = newStock
        } catch {
            self.error = "updating stock"
        }
    }
    
    private func updateHistory(oldMedicine: Medicine, newStock: Int, user: String) async {
        let diff = newStock - oldMedicine.stock
        guard diff != 0 else { return }
        
        let action = diff > 0
            ? "Increased stock of \(oldMedicine.name) by \(diff)"
            : "Decreased stock of \(oldMedicine.name) by \(-diff)"
        
        await addHistory(
            action: action,
            user: user,
            medicineId: oldMedicine.id,
            details: "\(user) \(action)",
            currentStock: newStock
        )
    }

    func updateMedicine(_ medicine: Medicine, user: String) async {
        self.error = nil
        
        guard let index = self.medicines.firstIndex(where: { $0.id == medicine.id }) else {
            self.error = "updating medicines"
            return
        }

        let currentMedicine = self.medicines[index]
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            
            try await repository.updateMedicine(medicine)

            
            await self.updateHistory(oldMedicine: currentMedicine, newStock: medicine.stock, user: user)
            
            if currentMedicine.aisle != medicine.aisle {
                await addHistory(
                    action: "Updated \(medicine.name)",
                    user: user,
                    medicineId: medicine.id,
                    details: "\(user) changed aisle from \(currentMedicine.aisle) to \(medicine.aisle)",
                    currentStock: medicine.stock
                )
                await AislesViewModel().add(medicine, in: medicine.aisle)
                await AislesViewModel().remove(medicine, from: currentMedicine.aisle)
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
        self.error = nil
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.history = try await repository.fetchHistory(for: medicine).sorted(by: { $0.timestamp > $1.timestamp})
        } catch {
            self.error = "fetching history for \(medicine.name)"
        }
    }
    
    func fetchAisles() async {
        self.error = nil
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.aisles = try await repository.fetchAllAisles(matching: "").compactMap { $0.name }
        } catch {
            self.error = "fetching aisles"
        }
    }
}
