//
//  HistoryEntryModelTests.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 04/09/2025.
//

import XCTest
@testable import MediStock

final class HistoryEntryModelTests: XCTestCase {

    func testHistoryEntryInit() {
        let history = HistoryEntry(id: "123", medicineId: "33", user: "user@test.app", action: "action", details: "details", timestamp: Date(), currentStock: 33)
        
        XCTAssertEqual(history.id, "123")
        XCTAssertEqual(history.medicineId, "33")
        XCTAssertEqual(history.user, "user@test.app")
        XCTAssertEqual(history.action, "action")
        XCTAssertEqual(history.details, "details")
        XCTAssertEqual(history.currentStock, 33)
    }
    
    func testHistoryData() {
        let history = HistoryEntry(id: "123", medicineId: "33", user: "user@test.app", action: "action", details: "details", timestamp: Date(), currentStock: 33)
        
        let data = history.data()
        
        guard let id = data["id"] as? String,
              let medicineId = data["medicineId"] as? String,
              let user = data["user"] as? String,
              let action = data["action"] as? String,
              let details = data["details"] as? String,
              let currentStock = data["currentStock"] as? Int else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(id, "123")
        XCTAssertEqual(medicineId, "33")
        XCTAssertEqual(user, "user@test.app")
        XCTAssertEqual(action, "action")
        XCTAssertEqual(details, "details")
        XCTAssertEqual(currentStock, 33)
    }
}
