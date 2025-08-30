import SwiftUI

struct AisleListView: View {
    @ObservedObject var viewModel = MedicineStockViewModel()
    @State private var showAddMedicine = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.aisles, id: \.self) { aisle in
                    NavigationLink{
                        MedicineListView(viewModel: viewModel, aisle: aisle)
                            .navigationTitle(aisle)
                    } label: {
                        Text(aisle)
                    }
                }
            }
            .navigationBarTitle("Aisles")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddMedicine = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            })
            .onAppear {
                Task {
                    await viewModel.fetchMedicines()
                }
            }
            .sheet(isPresented: $showAddMedicine) {
                NavigationStack {
                    AddMedicineView()
                }
            }
        }
    }
}

struct AisleListView_Previews: PreviewProvider {
    static var previews: some View {
        AisleListView()
    }
}
