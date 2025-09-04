//
//  MedicineModelTests.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 04/09/2025.
//

import XCTest
@testable import MediStock

final class MedicineModelTests: XCTestCase {

    func testMedicineInit() {
        let medicine = Medicine(id: "33", name: "Medicine 33", stock: 33, aisle: "Aisle 33")
        
        XCTAssertEqual(medicine.id, "33")
        XCTAssertEqual(medicine.name, "Medicine 33")
        XCTAssertEqual(medicine.stock, 33)
        XCTAssertEqual(medicine.aisle, "Aisle 33")
    }
    
    func testMedicineData() {
        let medicine = Medicine(id: "33", name: "Medicine 33", stock: 33, aisle: "Aisle 33")
        
        let data = medicine.data()
        
        guard let id = data["id"] as? String,
              let name = data["name"] as? String,
              let stock = data["stock"] as? Int,
              let aisle = data["aisle"] as? String else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(id, "33")
        XCTAssertEqual(name, "Medicine 33")
        XCTAssertEqual(stock, 33)
        XCTAssertEqual(aisle, "Aisle 33")
    }
}
