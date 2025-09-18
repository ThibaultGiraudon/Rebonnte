//
//  FirestoreRepositoryTests.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 04/09/2025.
//

import XCTest
@testable import MediStock

final class FirestoreRepositoryTests: XCTestCase {

    func testAddAndFetchAndDeleteMedicineShouldSucceed() async {
        let repository = FirestoreRepository()
        repository.pageSize = 2
        do {
            for medicine in FakeData().medicines {
                try await repository.addMedicine(medicine)
            }
        } catch {
            XCTFail("Adding medicine failed: \(error)")
        }
        
        var medicines: [Medicine] = []
        
        do {
            medicines = try await repository.fetchMedicines(sortedBy: .none, matching: "", nextItems: false)
            XCTAssertEqual(medicines.count, 2)
        } catch {
            XCTFail("Fetching medicines failed: \(error)")
        }
        
        do {
            let newMedicines = try await repository.fetchMedicines(sortedBy: .none, matching: "", nextItems: true)
            for medicine in newMedicines {
                medicines.append(medicine)
            }
            XCTAssertEqual(medicines.count, 4)
            guard let medicine6 = medicines.first(where: { $0.id == "6" }),
                  let medicine16 = medicines.firstIndex(where: { $0.id == "16" }),
                  let medicine33 = medicines.firstIndex(where: { $0.id == "33" }),
                  let medicine43 = medicines.firstIndex(where: { $0.id == "43" }) else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(medicine6)
            XCTAssertNotNil(medicine16)
            XCTAssertNotNil(medicine33)
            XCTAssertNotNil(medicine43)
        } catch {
            XCTFail("Fetching medicines failed: \(error)")
        }

        do {
            medicines = try await repository.fetchMedicines(sortedBy: .none, matching: "Medicine 33", nextItems: false)
            XCTAssertEqual(medicines.count, 1)
            guard let medicine33 = medicines.first(where: { $0.id == "33" }) else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(medicine33)
        } catch {
            XCTFail("Fetching Medicine 33 failed: \(error)")
        }

        do {
            medicines = try await repository.fetchAllMedicines(matching: "Medicine 33")
            XCTAssertEqual(medicines.count, 1)
            guard let medicine33 = medicines.first(where: { $0.id == "33" }) else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(medicine33)
        } catch {
            XCTFail("Fetching Medicine 33 failed: \(error)")
        }
        
        do {
            try await repository.deleteMedcines(FakeData().medicines)
            medicines = try await repository.fetchMedicines(sortedBy: .none, matching: "", nextItems: false)
            
            XCTAssertTrue(medicines.isEmpty)
        } catch {
            XCTFail("Deleting medicines failed: \(error)")
        }
    }
    
    func testUpdateStockandMedicine() async {
        let repository = FirestoreRepository()
        var medicine = FakeData().medicine
        do {
            try await repository.addMedicine(medicine)
        } catch {
            XCTFail("Adding medicine failed: \(error)")
        }
        
        medicine.name = "Medicine 333"
        
        do {
            try await repository.updateMedicine(medicine)
            let medicines = try await repository.fetchMedicines(sortedBy: .name, matching: "", nextItems: false)
            
            guard let medicine33 = medicines.first(where: { $0.id == "33" }) else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(medicine33.name, "Medicine 333")
        } catch {
            XCTFail("Updating medicine failed: \(error)")
        }
        
        do {
            try await repository.updateStock(for: medicine.id, amount: 333)
            let medicines = try await repository.fetchMedicines(sortedBy: .name, matching: "", nextItems: false)
            
            guard let medicine33 = medicines.first(where: { $0.id == "33" }) else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(medicine33.stock, 333)
        } catch {
            XCTFail("Updating medicine failed: \(error)")
        }
        
    }
    
    func testAddAndFetchHistory() async {
        let repository = FirestoreRepository()
        
        let historyEntry = HistoryEntry(medicineId: "33", user: "user@test.app", action: "add medicine 33", details: "user@test.app add medicine 33", currentStock: 33)
        
        do {
            try await repository.addHistory(historyEntry)
        } catch {
            XCTFail("Adding history failed: \(error)")
        }
        
        do {
            let history = try await repository.fetchHistory(for: Medicine(id: "33", name: "Medicine 33", stock: 33, aisle: "Aisle 33", normalStock: 40, warningStock: 10, alertStock: 5, icon: "pills", color: "000000"))
            
            XCTAssertEqual(history, [historyEntry])
        } catch {
            XCTFail("Fetching history failed: \(error)")
        }
    }

    func testAddAndFetchAndUpdateUser() async {
        let repository = FirestoreRepository()
        
        var user = FakeData().user
        
        do {
            try await repository.addUser(user)
        } catch {
            XCTFail("Adding user failed: \(error)")
        }
        
        do {
            let fetchedUser = try await repository.fetchUser(with: user.uid)
            XCTAssertEqual(fetchedUser, user)
        } catch {
            XCTFail("Fetching user faield: \(error)")
        }
        
        user.fullname = "Charles Leclerc"
        
        do {
            try await repository.updateUser(user)
            let fetchedUser = try await repository.fetchUser(with: user.uid)
            
            XCTAssertEqual(fetchedUser?.fullname, "Charles Leclerc")
        } catch {
            XCTFail("Updating user failed: \(error)")
        }
    }
    
}
