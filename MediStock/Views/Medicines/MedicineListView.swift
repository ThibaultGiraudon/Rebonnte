import SwiftUI

struct MedicineListView: View {
    @ObservedObject var medicinesVM: MedicineStockViewModel
    var aisle: String = ""

    var body: some View {
        List {
            ForEach(medicinesVM.medicines.filter { aisle.isEmpty ? true : $0.aisle == aisle }, id: \.id) { medicine in
                NavigationLink(destination: MedicineDetailView(medicine: medicine, medicinesVM: medicinesVM)) {
                    VStack(alignment: .leading) {
                        Text(medicine.name)
                            .font(.headline)
                        Text("Stock: \(medicine.stock)")
                            .font(.subheadline)
                    }
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
