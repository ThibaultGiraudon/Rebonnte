import SwiftUI

struct AisleListView: View {
    @ObservedObject var medicinesVM: MedicineStockViewModel
    @ObservedObject var addMedicinesVM: AddMedicineViewModel
    @State private var showAddMedicine = false

    var body: some View {
        NavigationView {
            List {
                ForEach(medicinesVM.aisles, id: \.self) { aisle in
                    NavigationLink{
                        MedicineListView(medicinesVM: medicinesVM, aisle: aisle)
                            .navigationTitle(aisle)
                    } label: {
                        Text(aisle)
                    }
                }
            }
            .navigationBarTitle("Aisles")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddMedicine = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            })
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
}

struct AisleListView_Previews: PreviewProvider {
    static var previews: some View {
        AisleListView(medicinesVM: MedicineStockViewModel(), addMedicinesVM: AddMedicineViewModel())
    }
}
