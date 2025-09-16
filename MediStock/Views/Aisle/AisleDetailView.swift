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
    var body: some View {
        VStack {
            Image(systemName: aisle.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48)
                .foregroundStyle(.customPrimary)
                .padding(20)
                .background {
                    Circle()
                        .fill(aisle.color.toColor())
                }
            Text(aisle.name)
                .font(.largeTitle)
                .foregroundStyle(.primaryText)
            Text("\(aisle.medicines.count) medicines available")
            
            MedicineListView(medicinesVM: medicinesVM, aisle: aisle.name)
        }
        .background(Color.customPrimary)
    }
}

#Preview {
    AisleDetailView(aisle: Aisle(name: "test", icon: "pills.fill", color: "00BB58"), aisleViewModel: AislesViewModel(), medicinesVM: MedicineStockViewModel())
}
