import SwiftUI

struct MedicineListView: View {
    @ObservedObject var medicinesVM: MedicineStockViewModel
    var aisle: String = ""
    
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        let filteredMedicines: [Medicine] = medicinesVM.filteredMedicines.filter { aisle.isEmpty ? true : $0.aisle == aisle }
        ScrollView {
            
            if filteredMedicines.isEmpty {
                ContentUnavailableView("No medicines found", systemImage: "")
            } else {
                ForEach(filteredMedicines, id: \.id) { medicine in
                    Button { coordinator.goToDetail(for: medicine) } label: {
                        MedicineRowView(medicine: medicine)
                            .padding(5)
                            .foregroundStyle(.primaryText)
                            .frame(maxWidth: .infinity)
                            .background(Color.customPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .onAppear {
                        if medicine == medicinesVM.medicines.last {
                            Task {
                                await medicinesVM.fetchMedicines(fetchNext: true)
                            }
                        }
                    }
                    .contextMenu {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            
                        }
                    }
                }
            }
        }
        .padding()
        .background {
            Color.background
                .ignoresSafeArea()
        }
        .onAppear {
            Task {
               await medicinesVM.fetchMedicines()
            }
        }
    }
}

struct MedicineListView_Previews: PreviewProvider {
    static var previews: some View {
        MedicineListView(medicinesVM: MedicineStockViewModel(), aisle: "").environmentObject(SessionStore())
            .environmentObject(AppCoordinator())
    }
}
