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
        HStack(alignment: .center) {
            Image(systemName: medicine.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding(10)
                .background {
                    Circle()
                        .fill(medicine.color.toColor().opacity(0.2))
                }
                .foregroundStyle(medicine.color.toColor())
                .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(medicine.name)
                    .font(.largeTitle)
                    .multilineTextAlignment(.leading)
                HStack {
                    Text("\(medicine.stock) in stock")
                        .foregroundStyle(.gray)
                    StockLinearIndicatorView(stock: medicine.stock, normalStock: medicine.normalStock, waringStock: medicine.warningStock, alertStock: medicine.alertStock)
                        .padding(.horizontal, 20)
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityValue("\(medicine.name), \(medicine.stock) in stock out of \(medicine.normalStock)")
    }
}

#Preview {
    MedicineRowView(medicine: Medicine(name: "Test", stock: 5, aisle: "Test", normalStock: 33, warningStock: 7, alertStock: 3, icon: "pills", color: "06ffb7"))
}
