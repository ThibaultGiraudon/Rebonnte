import SwiftUI

// TODO: search medicine and aisle with .contains in code
// TODO: keep actual filter on submit
// TODO: add xmark to delete search text
// TODO: aadd sort order by stock / name
// TODO: add full history with search on medicine
// TODO: jpeg file for test result not the best

struct AisleListView: View {
    @ObservedObject var medicinesVM: MedicineStockViewModel
    @ObservedObject var addMedicinesVM: AddMedicineViewModel
    @ObservedObject var aislesVM: AislesViewModel
    @ObservedObject var addAisleVM: AddAisleViewModel
    
    @State private var showAddAisle = false
    
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 10), count: 2)) {
                ForEach(aislesVM.aisles, id: \.self) { aisle in
                    Button {
                        coordinator.goToMedicinesList(for: aisle.name)
                    } label: {
                            AisleRowView(aisle: aisle)
                                .foregroundStyle(.primaryText)
                                .frame(maxWidth: .infinity)
                                .background(Color.customPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("\(aisle.name) button")
                    .accessibilityHint("Double-tap to see aisle's detail")
                }
            }
        }
        .padding()
        .background {
            Color.background
                .ignoresSafeArea()
        }
        .navigationTitle("Aisles")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddAisle = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Add button")
                .accessibilityHint("Double-tap to add new medicine")
            }
        }
        .onAppear {
            Task {
                await aislesVM.fetchAisles()
            }
        }
        .sheet(isPresented: $showAddAisle) {
            NavigationStack {
                AddAisleView(addAisleVM: addAisleVM)
            }
        }
    }
}

struct AisleListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AisleListView(
                medicinesVM: MedicineStockViewModel(),
                addMedicinesVM: AddMedicineViewModel(),
                aislesVM: AislesViewModel(),
                addAisleVM: AddAisleViewModel()
            )
                .environmentObject(AppCoordinator())
        }
    }
}
