//
//  AislesVMTests.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 18/09/2025.
//

import XCTest
@testable import MediStock

final class AislesVMTests: XCTestCase {

    @MainActor
    func testFetchAislesShouldSucceed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.aisles = FakeData().aisles
        let viewModel = AislesViewModel(repository: fakeRepo)
        
        await viewModel.fetchAisles()
        
        XCTAssertEqual(viewModel.aisles, FakeData().aisles)
    }
    
    @MainActor
    func testFetchAislesShouldFailed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.aisleError = FakeData().error
        let viewModel = AislesViewModel(repository: fakeRepo)
        
        await viewModel.fetchAisles()
        
        XCTAssertEqual(viewModel.error, "fetching aisles")
    }
    
    func testAddShouldSucceed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.aisles = FakeData().aisles
        let viewModel = AislesViewModel(repository: fakeRepo)

        await viewModel.add(FakeData().medicine, in: "Aisle 33")
        
        guard let aisle = viewModel.aisles.first(where: { $0.name == "Aisle 33" }) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(aisle.medicines, ["Medicine 34"])
    }
    
    func testAddShouldFailedWithNoAisle() async {
        let fakeRepo = FirestoreRepositoryFake()
        let viewModel = AislesViewModel(repository: fakeRepo)

        await viewModel.add(FakeData().medicine, in: "Aisle 33")
        
        XCTAssertEqual(viewModel.error, "adding medicine to aisle")
    }
    
    func testAddShouldFailed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.aisles = FakeData().aisles
        fakeRepo.aisleUpdateError = FakeData().error
        let viewModel = AislesViewModel(repository: fakeRepo)

        await viewModel.add(FakeData().medicine, in: "Aisle 33")
        
        XCTAssertEqual(viewModel.error, "adding medicine to aisle")
    }
    
    func testRemoveShouldSucceed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.aisles = [
            Aisle(name: "Aisle 33", icon: "pills", color: "000000", medicines: ["Medicine 34"])
        ]
        let viewModel = AislesViewModel(repository: fakeRepo)

        await viewModel.remove(FakeData().medicine, from: "Aisle 33")
        
        guard let aisle = viewModel.aisles.first(where: { $0.name == "Aisle 33" }) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(aisle.medicines, [])
    }
    
    func testRemoveShouldFailedWithNoAisle() async {
        let fakeRepo = FirestoreRepositoryFake()
        let viewModel = AislesViewModel(repository: fakeRepo)

        await viewModel.remove(FakeData().medicine, from: "Aisle 33")
        
        XCTAssertEqual(viewModel.error, "removing medicine from aisle")
    }
    
    func testRemoveShouldFailed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.aisles = FakeData().aisles
        fakeRepo.aisleUpdateError = FakeData().error
        let viewModel = AislesViewModel(repository: fakeRepo)

        await viewModel.remove(FakeData().medicine, from: "Aisle 33")
        
        XCTAssertEqual(viewModel.error, "removing medicine from aisle")
    }
    
    func testFilteredAisles() {
        let viewModel = AislesViewModel(repository: FirestoreRepositoryFake())
        viewModel.aisles = FakeData().aisles
        
        viewModel.filterText = ""
        
        XCTAssertEqual(viewModel.filteredAisles, FakeData().aisles)
        viewModel.filterText = "Aisle 6"
        XCTAssertEqual(viewModel.filteredAisles, [FakeData().aisles[0]])
    }

}
