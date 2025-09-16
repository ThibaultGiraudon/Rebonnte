import SwiftUI

// TODO: add aisle in firebase
// TODO: search medicine and aisle with .contains in code
// TODO: keep actual filter on submit
// TODO: add xmark to delete search text
// TODO: aadd sort order by stock / name
// TODO: add full history with search on medicine
// TODO: jpeg file for test result not the best

struct AisleListView: View {
    @ObservedObject var medicinesVM: MedicineStockViewModel
    @ObservedObject var addMedicinesVM: AddMedicineViewModel
    @ObservedObject var aislesVM: AislesViewModel
    @ObservedObject var addAisleVM: AddAisleViewModel
    
    @State private var showAddAisle = false
    
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        List {
            ForEach(medicinesVM.aisles, id: \.self) { aisle in
                Button {
                    coordinator.goToMedicinesList(for: aisle)
                } label: {
                    Text(aisle)
                        .foregroundStyle(.primaryText)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(aisle) button")
                .accessibilityHint("Double-tap to see aisle's detail")
            }
        }
        .listRowBackground(Color.customPrimary)
        .scrollContentBackground(.hidden)
        .background {
            Color.background
                .ignoresSafeArea()
        }
        .navigationTitle("Aisles")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddAisle = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Add button")
                .accessibilityHint("Double-tap to add new medicine")
            }
        }
        .onAppear {
            Task {
                await medicinesVM.fetchMedicines()
            }
        }
        .sheet(isPresented: $showAddAisle) {
            NavigationStack {
                AddAisleView(addAisleVM: addAisleVM)
            }
        }
    }
}

struct AisleListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AisleListView(
                medicinesVM: MedicineStockViewModel(),
                addMedicinesVM: AddMedicineViewModel(),
                aislesVM: AislesViewModel(),
                addAisleVM: AddAisleViewModel()
            )
                .environmentObject(AppCoordinator())
        }
    }
}
