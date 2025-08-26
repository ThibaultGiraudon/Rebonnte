import SwiftUI

struct AisleListView: View {
    @ObservedObject var viewModel = MedicineStockViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.aisles, id: \.self) { aisle in
                    NavigationLink(destination: MedicineListView(aisle: aisle)) {
                        Text(aisle)
                    }
                }
            }
            .navigationBarTitle("Aisles")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await viewModel.addRandomMedicine(user: "test_user")
                        }
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
        }
    }
}

struct AisleListView_Previews: PreviewProvider {
    static var previews: some View {
        AisleListView()
    }
}
