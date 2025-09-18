//
//  MedicinesStockVMTests.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import XCTest
@testable import MediStock

final class MedicinesStockVMTests: XCTestCase {

    @MainActor
    func testFetchMedicinesShouldSucceed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        
        await viewModel.fetchMedicines()
        
        XCTAssertEqual(viewModel.medicines, FakeData().medicines)
    }
    
    @MainActor
    func testFetchNextMedicinesShouldSucceed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        
        await viewModel.fetchMedicines(fetchNext: true)
        
        XCTAssertEqual(viewModel.medicines, FakeData().medicines)
    }
    
    @MainActor
    func testFetchMedicinesShouldFailed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicineError = FakeData().error
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        
        await viewModel.fetchMedicines(fetchNext: true)
        
        XCTAssertEqual(viewModel.error, "fetching medicines")
    }
    
    @MainActor
    func testDeleteMedicinesShouldSucceed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.aisles = [Aisle(name: "Aisle 16", icon: "pills", color: "000000", medicines: ["Medicine 34"])]
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        viewModel.medicines = FakeData().medicines
        
        await viewModel.delete(FakeData().medicine)
        
        XCTAssertNil(viewModel.error)
    }
    
    @MainActor
    func testDeleteMedicinesShouldFailed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicineError = FakeData().error
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        viewModel.medicines = FakeData().medicines
        
        await viewModel.delete(FakeData().medicine)
        
        XCTAssertEqual(viewModel.error, "deleting medicine")
    }
    
    @MainActor
    func testDeleteMedicinesShouldFailedInHistory() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.historyError = FakeData().error
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        viewModel.medicines = FakeData().medicines
        
        await viewModel.delete(FakeData().medicine)
        
        XCTAssertEqual(viewModel.error, "deleting history")
    }
    
    @MainActor
    func testUpdateMedicineShouldSucceed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        viewModel.medicines = FakeData().medicines
        
        await viewModel.updateMedicine(FakeData().medicine, user: "user123", aislesVM: AislesViewModel(repository: fakeRepo))
        
        guard let medicine = viewModel.medicines.first(where: { $0.id == "33" }) else {
            XCTFail()
            return
        }
                
        let historyUpdateName = viewModel.history.first(where: { $0.details == "user123 changed name from Medicine 33 to Medicine 34"})
        let historyUpdateAisle = viewModel.history.first(where: { $0.details == "user123 changed aisle from Aisle 33 to Aisle 16"})
        let historyUpdateStock = viewModel.history.first(where: { $0.details == "user123 Increased stock of Medicine 33 by 1"})
        XCTAssertEqual(medicine, FakeData().medicine)
        XCTAssertNotNil(historyUpdateName)
        XCTAssertNotNil(historyUpdateAisle)
        XCTAssertNotNil(historyUpdateStock)
    }
    
    @MainActor
    func testUpdateStockShouldSucceed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        viewModel.medicines = FakeData().medicines
        
        await viewModel.updateStock(for: FakeData().medicine, to: 34, by: "user123")
        
        guard let medicine = viewModel.medicines.first(where: { $0.id == "33" }) else {
            XCTFail()
            return
        }
        
        let historyUpdateStock = viewModel.history.first(where: { $0.details == "user123 Increased stock of Medicine 33 by 1"})
        XCTAssertEqual(medicine.stock, 34)
        XCTAssertNotNil(historyUpdateStock)
    }
    
    @MainActor
    func testUpdateStockShouldDoNothing() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        viewModel.medicines = FakeData().medicines
        
        await viewModel.updateStock(for: FakeData().medicine, to: 33, by: "user123")
        
        XCTAssertTrue(viewModel.history.isEmpty)
    }
    
    @MainActor
    func testUpdateStockDecreaseShouldSucceed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        viewModel.medicines = FakeData().medicines
        
        await viewModel.updateStock(for: FakeData().medicine, to: 32, by: "user123")
        
        guard let medicine = viewModel.medicines.first(where: { $0.id == "33" }) else {
            XCTFail()
            return
        }
                
        let historyUpdateStock = viewModel.history.first(where: { $0.details == "user123 Decreased stock of Medicine 33 by 1"})
        XCTAssertEqual(medicine.stock, 32)
        XCTAssertNotNil(historyUpdateStock)
    }
    
    @MainActor
    func testUpdateStockShouldFailed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicineError = FakeData().error
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        viewModel.medicines = FakeData().medicines
        
        await viewModel.updateStock(for: FakeData().medicine, to: 34, by: "user123")
        
        XCTAssertEqual(viewModel.error, "updating stock")
    }
    
    @MainActor
    func testUpdateStockShouldFailedWithNoMedicine() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicineError = FakeData().error
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        
        await viewModel.updateStock(for: FakeData().medicine, to: 34, by: "user123")
        
        XCTAssertEqual(viewModel.error, "updating stock")
    }
    
    @MainActor
    func testDecreaseMedicineShouldSucceed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        viewModel.medicines = FakeData().medicines
        
        var updatedMedicine = FakeData().medicine
        updatedMedicine.stock -= 2
        
        await viewModel.updateMedicine(updatedMedicine, user: "user123", aislesVM: AislesViewModel(repository: fakeRepo))
        
        guard let medicine = viewModel.medicines.first(where: { $0.id == "33" }) else {
            XCTFail()
            return
        }
                
        let historyUpdateName = viewModel.history.first(where: { $0.details == "user123 changed name from Medicine 33 to Medicine 34"})
        let historyUpdateAisle = viewModel.history.first(where: { $0.details == "user123 changed aisle from Aisle 33 to Aisle 16"})
        let historyUpdateStock = viewModel.history.first(where: { $0.details == "user123 Decreased stock of Medicine 33 by 1"})
        XCTAssertEqual(medicine, updatedMedicine)
        XCTAssertNotNil(historyUpdateName)
        XCTAssertNotNil(historyUpdateAisle)
        XCTAssertNotNil(historyUpdateStock)
    }
    
    @MainActor
    func testUpdateMedicineShouldFailedWithNoMedicines() async {
        let fakeRepo = FirestoreRepositoryFake()
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        
        await viewModel.updateMedicine(FakeData().medicine, user: "user123", aislesVM: AislesViewModel(repository: fakeRepo))
        
        XCTAssertEqual(viewModel.error, "updating medicines")
    }
    
    @MainActor
    func testUpdateMedicineShouldFailedWithError() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicineError = FakeData().error
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        
        await viewModel.updateMedicine(FakeData().medicine, user: "user123", aislesVM: AislesViewModel(repository: fakeRepo))
        
        XCTAssertEqual(viewModel.error, "updating medicines")
    }
    
    @MainActor
    func testUpdateMedicineShouldFailedWithHistoryError() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        fakeRepo.historyError = FakeData().error
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        viewModel.medicines = FakeData().medicines
        
        await viewModel.updateMedicine(FakeData().medicine, user: "user123", aislesVM: AislesViewModel(repository: fakeRepo))
        
        XCTAssertEqual(viewModel.error, "adding change to history")
    }
    
    @MainActor
    func testUpdateMedicineShouldFailedWithMedicineError() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        fakeRepo.medicineError = FakeData().error
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        viewModel.medicines = FakeData().medicines
        
        await viewModel.updateMedicine(FakeData().medicine, user: "user123", aislesVM: AislesViewModel(repository: fakeRepo))
        
        XCTAssertEqual(viewModel.error, "updating medicines")
    }
    
    @MainActor
    func testFetchHistoryShouldSucceed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.history = FakeData().history
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        
        await viewModel.fetchHistory(for: FakeData().medicine)
        
        XCTAssertEqual(viewModel.history, FakeData().history)
    }
    
    @MainActor
    func testFetchHistoryShouldFailed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.historyError = FakeData().error
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        
        await viewModel.fetchHistory(for: FakeData().medicine)
        
        XCTAssertEqual(viewModel.error, "fetching history for Medicine 34")
    }
    
    @MainActor
    func testFilteredMedicines() {
        let viewModel = MedicineStockViewModel(repository: FirestoreRepositoryFake())
        viewModel.medicines = FakeData().medicines
        
        XCTAssertEqual(viewModel.filteredMedicines(from: FakeData().medicines), FakeData().medicines)
        viewModel.filterText = "Medicine 2"
        XCTAssertEqual(viewModel.filteredMedicines(from: FakeData().medicines).count, 0)
        viewModel.filterText = "Medicine 33"
        XCTAssertEqual(viewModel.filteredMedicines(from: FakeData().medicines), [FakeData().medicines[0]])
    }
    
    @MainActor
    func testSortedMedicines() {
        let viewModel = MedicineStockViewModel(repository: FirestoreRepositoryFake())
        viewModel.medicines = FakeData().medicines
        
        viewModel.sortOption = .name
        XCTAssertEqual(viewModel.filteredMedicines(from: FakeData().medicines), FakeData().medicines.sorted { $0.name < $1.name })
        viewModel.sortOption = .stock
        XCTAssertEqual(viewModel.filteredMedicines(from: FakeData().medicines), FakeData().medicines.sorted { $0.stock < $1.stock })
        
        viewModel.sortAscending = false
        viewModel.sortOption = .none
        XCTAssertEqual(viewModel.filteredMedicines(from: FakeData().medicines), FakeData().medicines.sorted { _,_ in true })
        viewModel.sortOption = .name
        XCTAssertEqual(viewModel.filteredMedicines(from: FakeData().medicines), FakeData().medicines.sorted { $0.name > $1.name })
        viewModel.sortOption = .stock
        XCTAssertEqual(viewModel.filteredMedicines(from: FakeData().medicines), FakeData().medicines.sorted { $0.stock > $1.stock })
    }
    
    @MainActor
    func testWarningAndAlertMedicines() {
        let viewModel = MedicineStockViewModel(repository: FirestoreRepositoryFake())
        viewModel.medicines = FakeData().waringAndAlertMedicines
        
        XCTAssertEqual(viewModel.warningMedicines, [FakeData().waringAndAlertMedicines[1]])
        XCTAssertEqual(viewModel.alertMedicines, [FakeData().waringAndAlertMedicines[2]])
    }
    
    @MainActor
    func testMedicines() {
        let viewModel = MedicineStockViewModel(repository: FirestoreRepositoryFake())
        viewModel.medicines = FakeData().medicines
        
        XCTAssertEqual(viewModel.medicines(inAisle: "Aisle 33"), [FakeData().medicines[0]])
    }
    
    @MainActor
    func testFetchAislesShouldSucceed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.aisles = FakeData().aisles
        
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        
        await viewModel.fetchAisles()
        
        XCTAssertEqual(viewModel.aisles, FakeData().aislesString)
    }
    
    @MainActor
    func testFetchAislesShouldFailed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.aisleError = FakeData().error
        
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        
        await viewModel.fetchAisles()
        
        XCTAssertEqual(viewModel.error, "fetching aisles")
    }
}
