//
//  AppCoordinator.swift
//  MediStock
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import Foundation

class AppCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []
    
    func goToSignIn() {
        path.append(.signIn)
    }
    
    func goToRegister() {
        path.append(.register)
    }
    
    func goToDetail(for medicine: Medicine) {
        path.append(.detail(medicine: medicine))
    }
    
    func goToMedicinesList(for aisle: String) {
        path.append(.medicinesList(aisle: aisle))
    }
    
    func dismiss() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func resetNavigation() {
        path = []
    }
}

enum AppRoute: Hashable {
    case home
    case signIn
    case register
    case detail(medicine: Medicine)
    case medicinesList(aisle: String)
}
