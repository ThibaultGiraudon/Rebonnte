import SwiftUI

struct AllMedicinesView: View {
    @ObservedObject var viewModel = MedicineStockViewModel()
    @State private var showAddMedicine: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Filtrage et Tri
                HStack {
                    TextField("Filter by name", text: $viewModel.filterText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 10)
                        .onSubmit {
                            Task {
                                await viewModel.fetchMedicines()
                            }
                        }
                    
                    Spacer()

                    Picker("Sort by", selection: $viewModel.sortOption) {
                        Text("None").tag(SortOption.none)
                        Text("Name").tag(SortOption.name)
                        Text("Stock").tag(SortOption.stock)
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.trailing, 10)
                    .onChange(of: viewModel.sortOption) {
                        Task {
                            await viewModel.fetchMedicines()
                        }
                    }
                }
                .padding(.top, 10)
                
                // Liste des Médicaments
                List {
                    ForEach(viewModel.medicines, id: \.id) { medicine in
                        NavigationLink(destination: MedicineDetailView(medicine: medicine, viewModel: viewModel)) {
                            VStack(alignment: .leading) {
                                Text(medicine.name)
                                    .font(.headline)
                                Text("Stock: \(medicine.stock)")
                                    .font(.subheadline)
                            }
                        }
                        .onAppear {
                            if medicine == viewModel.medicines.last {
                                Task {
                                    await viewModel.fetchMedicines(fetchNext: true)
                                }
                            }
                        }
                    }
                    .onDelete { indexes in
                        Task {
                            await viewModel.deleteMedicines(at: indexes)
                        }
                    }
                }
                .navigationBarTitle("All Medicines")
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showAddMedicine = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                })
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchMedicines()
            }
        }
        .sheet(isPresented: $showAddMedicine, onDismiss: {
            Task {
                await viewModel.fetchMedicines()
            }
        }) {
            NavigationStack {
                AddMedicineView()
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
        AllMedicinesView()
    }
}
