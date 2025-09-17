//
//  EditMedicineView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 16/09/2025.
//

import SwiftUI

struct EditMedicineView: View {
    @Binding var medicine: Medicine
    @ObservedObject var medicinesVM: MedicineStockViewModel
    @EnvironmentObject private var session: SessionStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var isPresentingAislePicker = false
    private var shouldDisabled: Bool {
        medicine.name.isEmpty || medicine.aisle.isEmpty || medicine.stock < 0 || medicine.normalStock < 0 || medicine.warningStock < 0 || medicine.alertStock < 0
    }
    var body: some View {
        Form {
            Section {
                TextField("Medicine name", text: $medicine.name)
                HStack {
                    Text("Aisle")
                    Spacer()
                    Text(medicine.aisle)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isPresentingAislePicker.toggle()
                    }
                }
                
                if isPresentingAislePicker {
                    AislePickerView(selectedAisle: $medicine.aisle, in: medicinesVM.aisles)
                }
                
            }
            Section("Stock") {
                TextField("Stock", value: $medicine.stock, format: .number)
                TextField("Normal stock", value: $medicine.normalStock, format: .number)
                TextField("Warning stock", value: $medicine.warningStock, format: .number)
                TextField("Alert stock", value: $medicine.alertStock, format: .number)
            }
        }
        .listRowBackground(Color.customPrimary)
        .scrollContentBackground(.hidden)
        .background {
            Color.background
                .ignoresSafeArea()
        }
        .navigationTitle("Edit medicine")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await medicinesVM.fetchAisles()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Cancel button")
                .accessibilityHint("Double-tap to cancel action")
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        await medicinesVM.updateMedicine(medicine, user: session.session?.email ?? "")
                        if medicinesVM.error == nil {
                            dismiss()
                        }
                    }
                }
                .disabled(shouldDisabled)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Save button")
                .accessibilityHint(shouldDisabled ? "Button disabled, fill in all fields" : "Double-tap to save changes")
                .accessibilityIdentifier("saveMedicineButton")
            }
        }
    }
}

#Preview {
    @Previewable @State var medicine = Medicine(name: "sample", stock: 25, aisle: "Pills", normalStock: 25, warningStock: 25, alertStock: 25, icon: "pills", color: "06ffb7")
    EditMedicineView(medicine: $medicine, medicinesVM: MedicineStockViewModel())
}
