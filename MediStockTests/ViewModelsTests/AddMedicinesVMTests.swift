//
//  AddMedicinesVMTests.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import XCTest
@testable import MediStock

final class AddMedicinesVMTests: XCTestCase {
    
    @MainActor
    func testAddMedicineShouldSucceed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        let viewModel = AddMedicineViewModel(repository: fakeRepo)
        
        viewModel.name = "Medicine 33"
        viewModel.aisle = "Aisle 33"
        viewModel.stock = 33
        
        await viewModel.addMedicine(user: "test123")
        
        XCTAssertNil(viewModel.error)
    }
    
    @MainActor
    func testAddMedicineShouldFailedWithNoStock() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        let viewModel = AddMedicineViewModel(repository: fakeRepo)
        
        await viewModel.addMedicine(user: "test123")
        
        XCTAssertNil(viewModel.error)
    }
    
    @MainActor
    func testAddMedicineShouldFailedWhileAddingMedicine() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        fakeRepo.medicineError = FakeData().error
        let viewModel = AddMedicineViewModel(repository: fakeRepo)
        
        viewModel.name = "Medicine 33"
        viewModel.aisle = "Aisle 33"
        viewModel.stock = 33
        viewModel.normalStock = 33
        viewModel.warningStock = 32
        viewModel.alertStock = 31
        
        await viewModel.addMedicine(user: "test123")
        
        XCTAssertEqual(viewModel.error, "adding new medicines")
    }
    
    @MainActor
    func testAddMedicineShouldFailedWhileAddingHistory() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.medicines = FakeData().medicines
        fakeRepo.historyError = FakeData().error
        let viewModel = AddMedicineViewModel(repository: fakeRepo)
        
        viewModel.name = "Medicine 33"
        viewModel.aisle = "Aisle 33"
        viewModel.stock = 33
        viewModel.normalStock = 33
        viewModel.warningStock = 32
        viewModel.alertStock = 31
        
        await viewModel.addMedicine(user: "test123", tryAnyway: true)
        
        XCTAssertEqual(viewModel.error, "adding change to history")
    }
    
    @MainActor
    func testShouldDisabled() {
        let viewModel = AddMedicineViewModel()
        
        XCTAssertTrue(viewModel.shouldDisabled)
        viewModel.stock = -33
        XCTAssertTrue(viewModel.shouldDisabled)
        viewModel.name = "Medicine 33"
        XCTAssertTrue(viewModel.shouldDisabled)
        viewModel.aisle = "Aisle 33"
        XCTAssertTrue(viewModel.shouldDisabled)
        viewModel.stock = 33
        XCTAssertTrue(viewModel.shouldDisabled)
        viewModel.normalStock = 33
        XCTAssertTrue(viewModel.shouldDisabled)
        viewModel.warningStock = 32
        XCTAssertTrue(viewModel.shouldDisabled)
        viewModel.alertStock = 31
        XCTAssertFalse(viewModel.shouldDisabled)
    }
}
