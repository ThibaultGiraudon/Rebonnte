//
//  EditMedicineView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 16/09/2025.
//

import SwiftUI

struct EditMedicineView: View {
    @Binding var medicine: Medicine
    
    @Binding private var editedMedicine: Medicine
    @State private var isPresentingAislePicker = false
    
    @ObservedObject var medicinesVM: MedicineStockViewModel
    @EnvironmentObject private var session: SessionStore
    @Environment(\.dismiss) private var dismiss
    
    private var shouldDisabled: Bool {
        medicine.name.isEmpty || medicine.aisle.isEmpty || medicine.stock < 0 || medicine.normalStock < 0 || medicine.warningStock < 0 || medicine.alertStock < 0 || medicinesVM.isLoading
    }
    
    init(medicine: Binding<Medicine>, medicinesVM: MedicineStockViewModel) {
        self._medicine = medicine
        self._editedMedicine = medicine
        self.medicinesVM = medicinesVM
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Medicine name", text: $editedMedicine.name)
                HStack {
                    Text("Aisle")
                    Spacer()
                    Text(editedMedicine.aisle)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isPresentingAislePicker.toggle()
                    }
                }
                
                if isPresentingAislePicker {
                    AislePickerView(selectedAisle: $editedMedicine.aisle, in: medicinesVM.aisles)
                }
                
            }
            Section("Stock") {
                TextField("Stock", value: $editedMedicine.stock, format: .number)
                    .keyboardType(.numberPad)
                TextField("Normal stock", value: $editedMedicine.normalStock, format: .number)
                    .keyboardType(.numberPad)
                TextField("Warning stock", value: $editedMedicine.warningStock, format: .number)
                    .keyboardType(.numberPad)
                TextField("Alert stock", value: $editedMedicine.alertStock, format: .number)
                    .keyboardType(.numberPad)
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
                .disabled(medicinesVM.isLoading)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Cancel button")
                .accessibilityHint("Double-tap to cancel action")
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        self.medicine = editedMedicine
                        await medicinesVM.updateMedicine(medicine, user: session.session?.email ?? "", aislesVM: AislesViewModel())
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
