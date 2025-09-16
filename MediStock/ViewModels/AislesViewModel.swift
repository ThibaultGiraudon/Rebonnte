//
//  AisleViewModel.swift
//  MediStock
//
//  Created by Thibault Giraudon on 15/09/2025.
//

import Foundation

class AislesViewModel: ObservableObject {
    @Published var aisles: [Aisle] = []
    
    private let repository: FirestoreRepositoryInterface
    
    @Published var error: String?
    
    init(repository: FirestoreRepositoryInterface = FirestoreRepository()) {
        self.repository = repository
    }
    
    
    func fetchAisles() async {
        self.error = nil
        do {
            self.aisles = try await repository.fetchAllAisles(matching: "")
        } catch {
            self.error = "fetching aisles"
        }
    }
}
