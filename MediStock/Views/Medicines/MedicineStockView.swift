//
//  MedicineStockView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 16/09/2025.
//

import SwiftUI

struct MedicineStockView: View {
    @Binding var medicine: Medicine
    @ObservedObject var medicinesVM: MedicineStockViewModel
    
    @EnvironmentObject var session: SessionStore
    @State private var debounceTask: Task<Void, Never>?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 25) {
                VStack {
                    StockCircleIndicatorView(stock: medicine.stock, normalStock: medicine.normalStock, waringStock: medicine.warningStock, alertStock: medicine.alertStock)
                }
                VStack(alignment: .leading) {
                    stockIndicator(for: "Current stock", medicine.stock)
                    stockIndicator(for: "Normal stock", medicine.normalStock)
                    stockIndicator(for: "Warning stock", medicine.warningStock)
                    stockIndicator(for: "Alert stock", medicine.alertStock)
                }
            }
            Stepper("Update stock", value: $medicine.stock, in: 0...Int.max)
                .labelsHidden()
                .onChange(of: medicine.stock) {
                    debounceTask?.cancel()
                    
                    debounceTask = Task {
                        try? await Task.sleep(for: .milliseconds(500))
                        guard !Task.isCancelled else { return }
                        
                        await medicinesVM.updateStock(for: medicine, to: medicine.stock, by: session.session?.email ?? "")
                    }
                }
        }
    }
    
    @ViewBuilder
    func stockIndicator(for title: String, _ stock: Int) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.gray)
            Text("\(stock)")
                .foregroundStyle(.primaryText)
        }
    }
}

#Preview {
    @Previewable @State var medicine = Medicine(name: "Doliprane 500mg", stock: 25, aisle: "Pills", normalStock: 25, warningStock: 10, alertStock: 5, icon: "pills", color: "06ffb7")
    MedicineStockView(medicine: $medicine, medicinesVM: MedicineStockViewModel())
        .environmentObject(SessionStore())
}
