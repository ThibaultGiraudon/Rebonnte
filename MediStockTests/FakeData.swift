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
        Medicine(name: "Medicines 33", stock: 33, aisle: "Aisle 33"),
        Medicine(name: "Medicines 16", stock: 16, aisle: "Aisle 16"),
        Medicine(name: "Medicines 6", stock: 6, aisle: "Aisle 6"),
        Medicine(name: "Medicines 43", stock: 43, aisle: "Aisle 43"),
    ]
    
    var error: Error = URLError(.badURL)
}
