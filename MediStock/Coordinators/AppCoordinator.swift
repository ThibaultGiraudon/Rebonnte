//
//  AppCoordinator.swift
//  MediStock
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import Foundation

class AppCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []
    
    func goToRegister() {
        path.append(.register)
    }
    
    func goToDetail(for medicine: Medicine) {
        path.append(.detail(medicine: medicine))
    }
    
    func goToAisleList() {
        path.append(.aisleList)
    }
    
    func goToAisleDetail(for aisle: Aisle) {
        path.append(.aisleDetail(aisle: aisle))
    }
    
    func goToAddMedicine() {
        path.append(.addMedicine)
    }
    
    func goToMedicinesList(_ filter: MedicinesFilter = .all) {
        path.append(.medicineList(filter: filter))
    }
    
    func dismiss() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}

enum MedicinesFilter: Hashable {
    case all
    case alertStock
    case warningStock
    case aisle(_ aisle: String)
}

enum AppRoute: Hashable {
    case home
    case signIn
    case register
    case detail(medicine: Medicine)
    case aisleList
    case aisleDetail(aisle: Aisle)
    case addMedicine
    case medicineList(filter: MedicinesFilter)
}
