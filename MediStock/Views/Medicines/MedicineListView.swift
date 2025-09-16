import SwiftUI

struct MedicineListView: View {
    @ObservedObject var medicinesVM: MedicineStockViewModel
    var aisle: String = ""
    
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 10), count: 2)) {
                ForEach(medicinesVM.filteredMedicines.filter { aisle.isEmpty ? true : $0.aisle == aisle }, id: \.id) { medicine in
                    Button(action: { coordinator.goToDetail(for: medicine) }) {
                        MedicineRowView(medicine: medicine)
                            .padding()
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
