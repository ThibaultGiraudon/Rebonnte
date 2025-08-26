import SwiftUI

struct MedicineListView: View {
    @ObservedObject var viewModel: MedicineStockViewModel
    var aisle: String

    var body: some View {
        List {
            ForEach(viewModel.medicines.filter { $0.aisle == aisle }, id: \.id) { medicine in
                NavigationLink(destination: MedicineDetailView(medicine: medicine, viewModel: viewModel)) {
                    VStack(alignment: .leading) {
                        Text(medicine.name)
                            .font(.headline)
                        Text("Stock: \(medicine.stock)")
                            .font(.subheadline)
                    }
                }
            }
        }
        .navigationBarTitle(aisle)
        .onAppear {
            print(viewModel.medicines)
        }
//        .onAppear {
//            Task {
//                await viewModel.fetchMedicines()
//            }
//        }
    }
}

struct MedicineListView_Previews: PreviewProvider {
    static var previews: some View {
        MedicineListView(viewModel: MedicineStockViewModel(), aisle: "Aisle 1").environmentObject(SessionStore())
    }
}
