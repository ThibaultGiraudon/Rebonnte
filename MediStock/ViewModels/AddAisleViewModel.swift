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

    @Published var error: String?
    @Published var isLoading: Bool = false
    
    private let repository: FirestoreRepositoryInterface
    
    
    init(repository: FirestoreRepositoryInterface = FirestoreRepository()) {
        self.repository = repository
    }
    
    func addAisle() async {
        self.error = nil
        self.isLoading = true
        defer {
            self.restetFields()
            self.isLoading = true
        }
        do {
            let newAisle = Aisle(name: name, icon: icon, color: color)
            try await repository.addAisle(newAisle)
        } catch {
            self.error = "creating aisle"
        }
    }
    
    private func restetFields() {
        self.name = ""
        self.icon = "pills.fill"
        self.color = "6495ED"
    }
}
