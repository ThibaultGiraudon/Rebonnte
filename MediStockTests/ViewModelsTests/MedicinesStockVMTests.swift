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
    func testUpdateMedicineShouldSucceed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        viewModel.medicines = FakeData().medicines
        
        await viewModel.updateMedicine(FakeData().medicine, user: "user123")
        
        guard let medicine = viewModel.medicines.first(where: { $0.id == "33" }) else {
            XCTFail()
            return
        }
        
        print(viewModel.medicines)
        
        let historyUpdateName = viewModel.history.first(where: { $0.details == "user123 changed name from Medicine 33 to Medicine 34"})
        let historyUpdateAisle = viewModel.history.first(where: { $0.details == "user123 changed aisle from Aisle 33 to Aisle 34"})
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
        
        print(viewModel.history)
        
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
        
        await viewModel.updateMedicine(updatedMedicine, user: "user123")
        
        guard let medicine = viewModel.medicines.first(where: { $0.id == "33" }) else {
            XCTFail()
            return
        }
        
        print(viewModel.history)
        
        let historyUpdateName = viewModel.history.first(where: { $0.details == "user123 changed name from Medicine 33 to Medicine 34"})
        let historyUpdateAisle = viewModel.history.first(where: { $0.details == "user123 changed aisle from Aisle 33 to Aisle 34"})
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
        
        await viewModel.updateMedicine(FakeData().medicine, user: "user123")
        
        XCTAssertEqual(viewModel.error, "updating medicines")
    }
    
    @MainActor
    func testUpdateMedicineShouldFailedWithError() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicineError = FakeData().error
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        
        await viewModel.updateMedicine(FakeData().medicine, user: "user123")
        
        XCTAssertEqual(viewModel.error, "updating medicines")
    }
    
    @MainActor
    func testUpdateMedicineShouldFailedWithHistoryError() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        fakeRepo.historyError = FakeData().error
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        viewModel.medicines = FakeData().medicines
        
        await viewModel.updateMedicine(FakeData().medicine, user: "user123")
        
        XCTAssertEqual(viewModel.error, "adding change to history")
    }
    
    @MainActor
    func testUpdateMedicineShouldFailedWithMedicineError() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        fakeRepo.medicineError = FakeData().error
        let viewModel = MedicineStockViewModel(repository: fakeRepo)
        viewModel.medicines = FakeData().medicines
        
        await viewModel.updateMedicine(FakeData().medicine, user: "user123")
        
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
}
