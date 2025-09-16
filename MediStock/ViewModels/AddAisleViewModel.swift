//
//  AddAisleViewModel.swift
//  MediStock
//
//  Created by Thibault Giraudon on 16/09/2025.
//

import Foundation

class AddAisleViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var icon: String = "pills.fill"
    @Published var color: String = "6495ED"
    
    private let repository: FirestoreRepositoryInterface
    
    @Published var error: String?
    
    init(repository: FirestoreRepositoryInterface = FirestoreRepository()) {
        self.repository = repository
    }
    
    func addAisle() async {
        do {
            let newAisle = Aisle(name: name, icon: icon, color: color)
            try await repository.addAisle(newAisle)
        } catch {
            self.error = "creating aisle"
        }
    }
}
