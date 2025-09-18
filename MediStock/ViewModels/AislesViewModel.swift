//
//  AisleViewModel.swift
//  MediStock
//
//  Created by Thibault Giraudon on 15/09/2025.
//

import Foundation

class AislesViewModel: ObservableObject {
    @Published var aisles: [Aisle] = []
    @Published var filterText: String = ""
    
    var filteredAisles: [Aisle] {
        aisles.filter { filterText.isEmpty || $0.name.lowercased().contains(filterText.lowercased()) }
    }
    
    private let repository: FirestoreRepositoryInterface
    
    @Published var error: String?
    
    init(repository: FirestoreRepositoryInterface = FirestoreRepository()) {
        self.repository = repository
    }
    
    @MainActor
    func fetchAisles() async {
        self.error = nil
        do {
            self.aisles = try await repository.fetchAllAisles(matching: "")
        } catch {
            self.error = "fetching aisles"
        }
    }
    
    func add(_ medicine: Medicine, in aisleName: String) async {
        do {
            await self.fetchAisles()
            guard let index = self.aisles.firstIndex(where: { $0.name == aisleName}) else {
                self.error = "adding medicine to aisle"
                return
            }
            var aisle = self.aisles[index]
            aisle.medicines.append(medicine.name)
            try await repository.updateAisle(aisle)
            self.aisles[index] = aisle
        } catch {
            self.error = "adding medicine to aisle"
        }
    }
    
    func remove(_ medicine: Medicine, from aisleName: String) async {
        do {
            await self.fetchAisles()
            guard let index = self.aisles.firstIndex(where: { $0.name == aisleName}) else {
                self.error = "removing medicine to aisle"
                return
            }
            var aisle = self.aisles[index]
            aisle.medicines.removeAll { $0 == medicine.name }
            try await repository.updateAisle(aisle)
            self.aisles[index] = aisle
        } catch {
            self.error = "removing medicine to aisle"
        }
    }
}
