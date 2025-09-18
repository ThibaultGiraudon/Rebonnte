import SwiftUI

struct MedicineListView: View {
    @ObservedObject var medicinesVM: MedicineStockViewModel
    let filter: MedicinesFilter
    
    @EnvironmentObject var coordinator: AppCoordinator

    private var filteredMedicines: [Medicine] {
        switch filter {
        case .all:
            return medicinesVM.medicines
        case .warningStock:
            return medicinesVM.warningMedicines
        case .aisle(let aisle):
            return medicinesVM.medicines(inAisle: aisle)
        case .alertStock:
            return medicinesVM.alertMedicines
        }
    }
    
    var body: some View {
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
                            Task {
                                await medicinesVM.delete(medicine)
                            }
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
        MedicineListView(medicinesVM: MedicineStockViewModel(), filter: .warningStock).environmentObject(SessionStore())
            .environmentObject(AppCoordinator())
    }
}
