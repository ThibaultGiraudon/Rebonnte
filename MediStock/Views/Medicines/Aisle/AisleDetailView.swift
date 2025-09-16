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
                .frame(width: 100, height: 100)
                .background(Color(aisle.color.toColor()))
            Text(aisle.name)
                .font(.headline)
        }
    }
}

#Preview {
    AisleDetailView(aisle: Aisle(name: "Test", icon: "pills.fill", color: "00BB58"), aisleViewModel: AislesViewModel(), medicinesVM: MedicineStockViewModel())
}
