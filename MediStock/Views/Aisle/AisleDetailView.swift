//
//  AisleDetailView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 16/09/2025.
//

import SwiftUI

struct AisleDetailView: View {
    var aisle: Aisle
    @ObservedObject var aisleViewModel: AislesViewModel
    @ObservedObject var medicinesVM: MedicineStockViewModel
    
    @State private var showAddMedicine: Bool = false
    var body: some View {
        VStack {
            Image(systemName: aisle.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48)
                .foregroundStyle(aisle.color.toColor())
                .padding(20)
                .background {
                    Circle()
                        .fill(aisle.color.toColor().opacity(0.2))
                }
            Text(aisle.name)
                .font(.largeTitle)
                .foregroundStyle(.primaryText)
            Text("\(aisle.medicines.count) medicines available")
            
            MedicineListView(medicinesVM: medicinesVM, filter: .aisle(aisle.name))
        }
        .background(Color.customPrimary)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddMedicine = true
                } label: {
                    Image(systemName: "plus")
                        .tint(.primaryText)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Add button")
                .accessibilityHint("Double-tap to add new medicine")
            }
        }
        .sheet(isPresented: $showAddMedicine, onDismiss: {
            Task {
                await medicinesVM.fetchMedicines()
            }
        }) {
            NavigationStack {
                AddMedicineView(addMedicinesVM: AddMedicineViewModel(aisle: aisle.name))
            }
        }
    }
}

#Preview {
    AisleDetailView(aisle: Aisle(name: "test", icon: "pills.fill", color: "00BB58"), aisleViewModel: AislesViewModel(), medicinesVM: MedicineStockViewModel())
}
