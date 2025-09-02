import SwiftUI

struct AllMedicinesView: View {
    @ObservedObject var medicinesVM: MedicineStockViewModel
    @ObservedObject var addMedicinesVM: AddMedicineViewModel
    @State private var showAddMedicine: Bool = false
    
    var body: some View {
        VStack {
            // Filtrage et Tri
            HStack {
                TextField("Filter by name", text: $medicinesVM.filterText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 10)
                    .onSubmit {
                        Task {
                            await medicinesVM.fetchMedicines()
                        }
                    }
                
                Spacer()
                
                Picker("Sort by", selection: $medicinesVM.sortOption) {
                    Text("None").tag(SortOption.none)
                    Text("Name").tag(SortOption.name)
                    Text("Stock").tag(SortOption.stock)
                }
                .tint(.primaryText)
                .pickerStyle(MenuPickerStyle())
                .padding(.trailing, 10)
                .onChange(of: medicinesVM.sortOption) {
                    Task {
                        await medicinesVM.fetchMedicines()
                    }
                }
            }
            .padding(.top, 10)
            
            // Liste des Médicaments
            MedicineListView(medicinesVM: medicinesVM)
        }
        .navigationTitle("All Medicines")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddMedicine = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.primaryText)
                }
            }
        }
        .onAppear {
            Task {
                await medicinesVM.fetchMedicines()
            }
        }
        .sheet(isPresented: $showAddMedicine, onDismiss: {
            Task {
                await medicinesVM.fetchMedicines()
            }
        }) {
            NavigationStack {
                AddMedicineView(addMedicinesVM: addMedicinesVM)
            }
        }
        
    }
}

enum SortOption: String, CaseIterable, Identifiable, Equatable {
    case none
    case name
    case stock

    var id: String { self.rawValue }
    
    var value: String {
        switch self {
        case .none:
            "id"
        case .name:
            "name"
        case .stock:
            "stock"
        }
    }
}

struct AllMedicinesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AllMedicinesView(medicinesVM: MedicineStockViewModel(), addMedicinesVM: AddMedicineViewModel())
        }
    }
}
