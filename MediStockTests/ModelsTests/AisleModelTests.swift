//
//  AisleModelTests.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 18/09/2025.
//

import XCTest
@testable import MediStock

final class AisleModelTests: XCTestCase {

    func testAisleInit() {
        let aisle = Aisle(name: "Aisle 1", icon: "pills", color: "000000")
        
        XCTAssertEqual(aisle.name, "Aisle 1")
        XCTAssertEqual(aisle.icon, "pills")
        XCTAssertEqual(aisle.color, "000000")
    }

    
    func testCreateAisleWithInitDataShouldSucceed() {
        guard let aisle = Aisle(FakeData().aisleData) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(aisle.name, "Aisle 33")
        XCTAssertEqual(aisle.icon, "pills")
        XCTAssertEqual(aisle.color, "000000")
    }
    
    func testCreateAisleWithInitDataShouldBeNil() {
        let aisle = Aisle(FakeData().wrongAisleData)
        
        XCTAssertNil(aisle)
    }
    
    func testUserData() {
        let aisle = Aisle(name: "Aisle 1", icon: "pills", color: "00000")
        
        guard let newAisle = Aisle(aisle.data()) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(aisle, newAisle)
    }
}
