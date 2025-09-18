import Foundation

/// View model responsible for managing medicines, their stock, aisles, and history.
///
/// `MedicineStockViewModel` provides operations to fetch, update, and delete medicines.
/// It also handles stock management, history tracking, and aisle associations.
@MainActor
class MedicineStockViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// The list of medicines currently available.
    @Published var medicines: [Medicine] = []
    
    /// The list of aisle names fetched from the repository.
    var aisles: [String] = []
    
    /// The history of stock changes and updates for medicines.
    @Published var history: [HistoryEntry] = []
    
    /// Text used to filter medicines by name.
    @Published var filterText: String = ""
    
    /// Current sorting option for medicines.
    @Published var sortOption: SortOption = .none
    
    /// Whether sorting should be ascending (`true`) or descending (`false`).
    @Published var sortAscending: Bool = true
    
    /// An optional error message when an operation fails.
    @Published var error: String? = nil
    
    /// Indicates whether a network or database operation is in progress.
    @Published var isLoading: Bool = false
    
    // MARK: - Computed Properties
    
    /// Medicines that have reached their warning threshold but are not in alert state.
    var warningMedicines: [Medicine] { medicines.filter { $0.stock <= $0.warningStock && $0.stock > $0.alertStock } }
    
    /// Medicines that have reached or fallen below their alert threshold.
    var alertMedicines: [Medicine] { medicines.filter { $0.stock <= $0.alertStock } }
    
    // MARK: - Private Properties
    
    /// Repository handling Firestore operations.
    private let repository: FirestoreRepositoryInterface
    
    // MARK: - Initialization
    
    /// Initializes a new `MedicineStockViewModel`.
    ///
    /// - Parameter repository: The Firestore repository to use (default is `FirestoreRepository`).
    init(repository: FirestoreRepositoryInterface = FirestoreRepository()) {
        self.repository = repository
    }
    
    // MARK: - Filtering & Sorting
    
    /// Returns medicines filtered by `filterText` and sorted according to the current `sortOption`.
    ///
    /// - Parameter medicines: The array of medicines to filter and sort.
    /// - Returns: A filtered and sorted list of medicines.
    func filteredMedicines(from medicines: [Medicine]) -> [Medicine] {
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
    
    /// Returns all medicines belonging to a specific aisle.
    ///
    /// - Parameter aisle: The aisle name.
    /// - Returns: An array of medicines in the specified aisle.
    func medicines(inAisle aisle: String) -> [Medicine] {
        self.medicines.filter { $0.aisle == aisle }
    }
    
    // MARK: - Fetching
    
    /// Fetches medicines from the repository.
    ///
    /// - Parameter fetchNext: Whether to fetch the next batch of medicines (for pagination).
    func fetchMedicines(fetchNext: Bool = false) async {
        self.error = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchedMedicines = try await repository.fetchMedicines(sortedBy: sortOption, matching: filterText, nextItems: fetchNext)
            if fetchNext {
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

    
    /// Fetches aisle names from the repository.
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
    
    /// Fetches the history of a specific medicine.
    ///
    /// - Parameter medicine: The medicine whose history should be fetched.
    func fetchHistory(for medicine: Medicine) async {
        self.error = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.history = try await repository.fetchHistory(for: medicine).sorted(by: { $0.timestamp > $1.timestamp })
        } catch {
            self.error = "fetching history for \(medicine.name)"
        }
    }
    
    // MARK: - Deleting
    
    /// Deletes a medicine and its related history from the repository.
    ///
    /// - Parameter medicine: The medicine to delete.
    func delete(_ medicine: Medicine) async {
        self.error = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await repository.deleteMedicines([medicine])
            await self.deleteHistory(for: medicine)
            
            let aisles = try await repository.fetchAllAisles(matching: medicine.aisle)
            guard var aisle = aisles.first else { return }
            
            aisle.medicines.removeAll { $0 == medicine.name }
            try await repository.updateAisle(aisle)
            
            await self.fetchMedicines()
        } catch {
            self.error = "deleting medicine"
        }
    }
    
    /// Deletes the history of a specific medicine.
    ///
    /// - Parameter medicine: The medicine whose history should be deleted.
    private func deleteHistory(for medicine: Medicine) async {
        self.error = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            let historyToDelete = try await repository.fetchHistory(for: medicine)
            try await repository.deleteHistory(historyToDelete)
        } catch {
            self.error = "deleting history"
        }
    }
    
    // MARK: - Updating
    
    /// Updates the stock of a medicine and logs the change in history.
    ///
    /// - Parameters:
    ///   - medicine: The medicine to update.
    ///   - newStock: The new stock value.
    ///   - user: The user performing the update.
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
    
    /// Logs stock changes in history when a medicine's stock is updated.
    private func updateHistory(oldMedicine: Medicine, newStock: Int, user: String) async {
        let diff = newStock - oldMedicine.stock
        guard diff != 0 else { return }
        
        let action = diff > 0
            ? "Increased stock of \(oldMedicine.name) by \(diff) current stock: \(newStock)"
            : "Decreased stock of \(oldMedicine.name) by \(-diff) current stock: \(newStock)"
        
        await addHistory(
            action: action,
            user: user,
            medicineId: oldMedicine.id,
            details: "\(user) \(action)",
            currentStock: newStock
        )
    }
    
    /// Updates a medicine, its stock, and aisle associations if needed.
    ///
    /// - Parameters:
    ///   - medicine: The updated medicine object.
    ///   - user: The user performing the update.
    ///   - aislesVM: The view model responsible for aisle management.
    func updateMedicine(_ medicine: Medicine, user: String, aislesVM: AislesViewModel) async {
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
                    details: "\(user) moves \(medicine.name) from \(currentMedicine.aisle) to \(medicine.aisle)",
                    currentStock: medicine.stock
                )
                await aislesVM.add(medicine, in: medicine.aisle)
                await aislesVM.remove(medicine, from: currentMedicine.aisle)
            }
            
            if currentMedicine.name != medicine.name {
                await addHistory(
                    action: "Updated \(medicine.name)",
                    user: user,
                    medicineId: medicine.id,
                    details: "\(user) renames \(currentMedicine.name) to \(medicine.name)",
                    currentStock: medicine.stock
                )
            }
            
            self.medicines[index] = medicine
        } catch {
            self.error = "updating medicines"
        }
    }
    
    // MARK: - History
    
    /// Adds a new entry to the medicine history.
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
}
