import SwiftUI

struct MedicineListView: View {
    @ObservedObject var medicinesVM: MedicineStockViewModel
    var aisle: String = ""
    
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        List {
            ForEach(medicinesVM.medicines.filter { aisle.isEmpty ? true : $0.aisle == aisle }, id: \.id) { medicine in
                Button(action: { coordinator.goToDetail(for: medicine) }) {
                    VStack(alignment: .leading) {
                        Text(medicine.name)
                            .font(.headline)
                        Text("Stock: \(medicine.stock)")
                            .font(.subheadline)
                    }
                    .foregroundStyle(.primaryText)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("\(medicine.name), stock of \(medicine.stock)")
                    .accessibilityHint("Double-tap to see medicine's detail")
                }
                .onAppear {
                    if medicine == medicinesVM.medicines.last {
                        Task {
                            await medicinesVM.fetchMedicines(fetchNext: true)
                        }
                    }
                }
            }
            .onDelete { indexes in
                Task {
                    await medicinesVM.deleteMedicines(at: indexes)
                }
            }
        }
        .listRowBackground(Color.customPrimary)
        .scrollContentBackground(.hidden)
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
        MedicineListView(medicinesVM: MedicineStockViewModel(), aisle: "Aisle 1").environmentObject(SessionStore())
    }
}
