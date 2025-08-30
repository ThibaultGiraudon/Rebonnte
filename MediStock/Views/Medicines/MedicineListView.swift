import SwiftUI

struct MedicineListView: View {
    @ObservedObject var viewModel: MedicineStockViewModel
    var aisle: String = ""

    var body: some View {
        List {
            ForEach(viewModel.medicines.filter { aisle.isEmpty ? true : $0.aisle == aisle }, id: \.id) { medicine in
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
        .onAppear {
            Task {
               await viewModel.fetchMedicines()
            }
        }
    }
}

struct MedicineListView_Previews: PreviewProvider {
    static var previews: some View {
        MedicineListView(viewModel: MedicineStockViewModel(), aisle: "Aisle 1").environmentObject(SessionStore())
    }
}
