import SwiftUI

struct AisleListView: View {
    @ObservedObject var medicinesVM: MedicineStockViewModel
    @ObservedObject var addMedicinesVM: AddMedicineViewModel
    
    @State private var showAddMedicine = false
    
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
                    showAddMedicine = true
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
        .sheet(isPresented: $showAddMedicine) {
            NavigationStack {
                AddMedicineView(addMedicinesVM: addMedicinesVM)
            }
        }
    }
}

struct AisleListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AisleListView(medicinesVM: MedicineStockViewModel(), addMedicinesVM: AddMedicineViewModel())
                .environmentObject(AppCoordinator())
        }
    }
}
