import SwiftUI

struct AisleListView: View {
    @ObservedObject var addMedicinesVM: AddMedicineViewModel
    @ObservedObject var aislesVM: AislesViewModel
    @ObservedObject var addAisleVM: AddAisleViewModel
    
    @State private var showAddAisle = false
    
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $aislesVM.filterText)
                
                if !aislesVM.filterText.isEmpty {
                    Image(systemName: "xmark.circle.fill")
                        .onTapGesture {
                            aislesVM.filterText = ""
                        }
                }
            }
            .padding(5)
            .background {
                Capsule().stroke()
            }
            .foregroundStyle(.gray)
            .padding()
            
            ScrollView {
                if aislesVM.filteredAisles.isEmpty {
                    ContentUnavailableView("No aisle found", systemImage: "xmark.bin")
                } else {
                    ForEach(aislesVM.filteredAisles, id: \.self) { aisle in
                        Button {
                            coordinator.goToAisleDetail(for: aisle)
                        } label: {
                            AisleRowView(aisle: aisle)
                                .foregroundStyle(.primaryText)
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
        }
        .background {
            Color.customPrimary
                .ignoresSafeArea()
        }
        .navigationTitle("Aisles")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddAisle = true
                } label: {
                    Image(systemName: "plus")
                        .tint(.primaryText)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Add button")
                .accessibilityHint("Double-tap to add new aisle")
            }
        }
        .onAppear {
            Task {
                await aislesVM.fetchAisles()
            }
        }
        .sheet(isPresented: $showAddAisle, onDismiss: {
            Task {
                await aislesVM.fetchAisles()
            }
        }) {
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
                addMedicinesVM: AddMedicineViewModel(),
                aislesVM: AislesViewModel(),
                addAisleVM: AddAisleViewModel()
            )
                .environmentObject(AppCoordinator())
        }
    }
}
