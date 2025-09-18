//
//  AddAisleVMTests.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 18/09/2025.
//

import XCTest
@testable import MediStock

final class AddAisleVMTests: XCTestCase {

    @MainActor
    func testAddAisleShouldSucceed() async {
        let fakeRepo = FirestoreRepositoryFake()
        let viewModel = AddAisleViewModel(repository: fakeRepo)
        
        await viewModel.addAisle()
        XCTAssertNil(viewModel.error)
    }
    
    @MainActor
    func testAddAisleShouldFailed() async {
        let fakeRepo = FirestoreRepositoryFake()
        fakeRepo.aisleError = FakeData().error
        let viewModel = AddAisleViewModel(repository: fakeRepo)
        
        await viewModel.addAisle()
        XCTAssertEqual(viewModel.error, "creating aisle")
    }

}
