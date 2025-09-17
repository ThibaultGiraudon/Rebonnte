import SwiftUI

struct AllMedicinesView: View {
    @ObservedObject var medicinesVM: MedicineStockViewModel
    @ObservedObject var addMedicinesVM: AddMedicineViewModel
    @State private var showAddMedicine: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $medicinesVM.filterText)
                        .onSubmit {
                            Task {
                                await medicinesVM.fetchMedicines()
                            }
                        }
                    if !medicinesVM.filterText.isEmpty {
                        Image(systemName: "xmark.circle.fill")
                            .onTapGesture {
                                Task {
                                    medicinesVM.filterText = ""
                                    await medicinesVM.fetchMedicines()
                                }
                            }
                    }
                }
                .padding(5)
                .background {
                    Capsule().stroke()
                }
                .foregroundStyle(.gray)
                
                Image(systemName: medicinesVM.sortAscending ? "arrow.up" : "arrow.down")
                    .onTapGesture {
                        medicinesVM.sortAscending.toggle()
                    }
                
                Picker("Sort by", selection: $medicinesVM.sortOption) {
                    Text("None").tag(SortOption.none)
                    Text("Name").tag(SortOption.name)
                    Text("Stock").tag(SortOption.stock)
                }
                .tint(.primaryText)
                .pickerStyle(MenuPickerStyle())
                .padding(.trailing, 10)
            }
            .padding([.top, .leading, .bottom], 10)
            
            MedicineListView(medicinesVM: medicinesVM)
        }
        .background {
            Color.customPrimary
                .ignoresSafeArea()
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
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Show add medicine form")
                .accessibilityHint("Double-tap to open adding view")
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
