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
                }
            }
        }
        .navigationTitle("Aisles")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddMedicine = true
                } label: {
                    Image(systemName: "plus")
                }
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
        }
    }
}
