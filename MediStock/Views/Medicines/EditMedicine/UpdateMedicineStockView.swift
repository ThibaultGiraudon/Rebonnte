//
//  UpdateMedicineStockView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 17/09/2025.
//

import SwiftUI

struct UpdateMedicineStockView: View {
    @State var medicine: Medicine
    @ObservedObject var medicinesVM: MedicineStockViewModel
    var initialStock: Int
    
    @State private var debounceTask: Task<Void, Never>?
    
    @EnvironmentObject var session: SessionStore
    
    init(medicine: Medicine, medicinesVM: MedicineStockViewModel) {
        self.medicine = medicine
        self.initialStock = medicine.stock
        self.medicinesVM = medicinesVM
    }
    var body: some View {
        VStack {
            Text("Update stock for \(medicine.name)")
                .font(.title)
            Text("\(medicine.stock)/\(medicine.normalStock) medicines in stock")
                StockLinearIndicatorView(stock: medicine.stock, normalStock: medicine.normalStock, waringStock: medicine.warningStock, alertStock: medicine.alertStock)
            Stepper("Stock: \(medicine.stock)", value: $medicine.stock, in: 0...Int.max)
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
        .padding()
    }
}

#Preview {
    UpdateMedicineStockView(
        medicine:Medicine(name: "Test", stock: 33, aisle: "Aisle 1", normalStock: 60, warningStock: 20, alertStock: 10, icon: "pills", color: "002255"),
        medicinesVM: MedicineStockViewModel()
    )
}
