//
//  MedicineRowView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 16/09/2025.
//

import SwiftUI

struct MedicineRowView: View {
    var medicine: Medicine
    var body: some View {
        VStack(alignment: .leading) {
            Text(medicine.name)
            StockLinearIndicatorView(stock: medicine.stock, normalStock: medicine.normalStock, waringStock: medicine.warningStock, alertStock: medicine.alertStock)
        }
        
    }
}

#Preview {
    MedicineRowView(medicine: Medicine(name: "Test", stock: 5, aisle: "Test", normalStock: 33, warningStock: 7, alertStock: 3))
}
