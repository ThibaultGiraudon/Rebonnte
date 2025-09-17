//
//  HomeView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var medicinesVM: MedicineStockViewModel
    @ObservedObject var addMedicineVM: AddMedicineViewModel
    @ObservedObject var aislesVM: AislesViewModel
    @ObservedObject var addAisleVM: AddAisleViewModel

    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var coordinator: AppCoordinator
    
    @State private var selectedMedicineToUpdate: Medicine?
    @State private var selectedMedicineToMove: Medicine?
    
    init(medicinesVM: MedicineStockViewModel, addMedicineVM: AddMedicineViewModel, aislesVM: AislesViewModel, addAisleVM: AddAisleViewModel) {
        self.medicinesVM = medicinesVM
        self.addMedicineVM = addMedicineVM
        self.aislesVM = aislesVM
        self.addAisleVM = addAisleVM
    }
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 10), count: 2)) {
                    CardView(icon: "pills", title: "Total medicines", color: .blue, value: medicinesVM.medicines.count)
                        .onTapGesture {
                            coordinator.goToMedicinesList(.all)
                        }
                    CardView(icon: "archivebox", title: "Total aisles", color: .purple, value: aislesVM.aisles.count)
                        .onTapGesture {
                            coordinator.goToAisleList()
                        }
                    CardView(icon: "exclamationmark.triangle", title: "Critical stock", color: .red, value: medicinesVM.alertMedicines.count)
                        .onTapGesture {
                            coordinator.goToMedicinesList(.alertStock)
                        }
                    CardView(icon: "clock", title: "Warning stock", color: .yellow, value: medicinesVM.warningMedicines.count)
                        .onTapGesture {
                            coordinator.goToMedicinesList(.warningStock)
                        }
                }
                .padding(.bottom)
                
                Text("Quick actions")
                    .font(.title2.bold())
                VStack {
                    Button { coordinator.goToAddMedicine() } label: {
                        customLabel("Add medicine", systemImage: "plus.circle", color: .blue)
                    }
                    
                    NavigationLink {
                        MedicinePickerView(medicines: medicinesVM.medicines, selectedMedicine: $selectedMedicineToUpdate)
                    } label: {
                        customLabel("Update stock", systemImage: "arrow.up.arrow.down", color: .yellow)
                    }
                    .pickerStyle(.navigationLink)
                    
                    NavigationLink {
                        MedicinePickerView(medicines: medicinesVM.medicines, selectedMedicine: $selectedMedicineToMove)
                    } label: {
                        customLabel("Move medicine", systemImage: "arrow.left.arrow.right", color: .green)
                    }
                    .pickerStyle(.navigationLink)
                }
            }
            .sheet(item: $selectedMedicineToUpdate, onDismiss: { Task { await medicinesVM.fetchMedicines()}}) { medicine in
                UpdateMedicineStockView(medicine: medicine, medicinesVM: medicinesVM)
                    .padding(.top)
                    .presentationDetents([.fraction(0.3)])
                    .presentationDragIndicator(.visible)
            }
            .sheet(item: $selectedMedicineToMove, onDismiss: { Task { await medicinesVM.fetchMedicines()}}) { medicine in
                MovesMedicineView(medicine: medicine, aislesVM: aislesVM, medicinesVM: medicinesVM)
                    .padding(.top)
                    .presentationDetents([.fraction(0.5)])
                    .presentationDragIndicator(.visible)
            }
        }
        .task {
            await medicinesVM.fetchMedicines()
            await aislesVM.fetchAisles()
        }
        .navigationTitle("Dashboard")
        .padding()
        .background {
            Color.background
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func customLabel(_ title: String, systemImage: String, color: Color) -> some View {
            HStack {
                Image(systemName: systemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(color)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundStyle(.gray)
            }
            .font(.title2)
            .padding()
            .foregroundColor(.primaryText)
            .background(Color.customPrimary)
            .cornerRadius(8)
    }
}

#Preview {
    NavigationStack {
        HomeView(
            medicinesVM: MedicineStockViewModel(),
            addMedicineVM: AddMedicineViewModel(),
            aislesVM: AislesViewModel(),
            addAisleVM: AddAisleViewModel()
        )
        .environmentObject(AppCoordinator())
        .environmentObject(SessionStore())
    }
}
