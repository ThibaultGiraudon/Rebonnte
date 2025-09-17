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
    
    func goToAisleDetail(for aisle: Aisle) {
        path.append(.aisleDetail(aisle: aisle))
    }
    
    func goToAddMedicine() {
        path.append(.addMedicine)
    }
    
    func dismiss() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}

enum AppRoute: Hashable {
    case home
    case signIn
    case register
    case detail(medicine: Medicine)
    case aisleDetail(aisle: Aisle)
    case addMedicine
}
