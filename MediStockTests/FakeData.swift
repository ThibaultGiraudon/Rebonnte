//
//  FakeData.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import Foundation
@testable import MediStock

struct FakeData {
    var medicines: [Medicine] = [
        Medicine(id: "33", name: "Medicine 33", stock: 33, aisle: "Aisle 33"),
        Medicine(id: "16", name: "Medicine 16", stock: 16, aisle: "Aisle 16"),
        Medicine(id: "6", name: "Medicine 6", stock: 6, aisle: "Aisle 6"),
        Medicine(id: "43", name: "Medicine 43", stock: 43, aisle: "Aisle 43"),
    ]
    
    var aisles: [String] = [
        "Aisle 16",
        "Aisle 33",
        "Aisle 43",
        "Aisle 6"
    ]
    
    var medicine: Medicine = Medicine(id: "33", name: "Medicine 34", stock: 34, aisle: "Aisle 34")
    
    var history: [HistoryEntry] = [
        HistoryEntry(id: "33", medicineId: "33", user: "user123", action: "updated medicines", details: "updates medicines", timestamp: Date() + 86400 ,currentStock: 33),
        HistoryEntry(id: "16", medicineId: "16", user: "user123", action: "updated medicines", details: "updates medicines", currentStock: 16)
    ]
    
    var error: Error = URLError(.badURL)
    
    var user: User = User(uid: "123", email: "user@test.app", fullname: "New user")
    
    var wrongUserData: [String: Any] = [
        "email": "user@test.app",
        "uid": "123",
        "fullname": "New user",
    ]
    
    var userData: [String: Any] = [
        "email": "user@test.app",
        "uid": "123",
        "fullname": "New user",
        "imageURL": "testurl"
    ]
    
    let wrongMedicineData: [String: Any] = [
        "id": "33",
        "name": "Medicine 33",
        "stock": 33
    ]

    let medicineData: [String: Any] = [
        "id": "33",
        "name": "Medicine 33",
        "stock": 33,
        "aisle": "Aisle 33"
    ]
}
