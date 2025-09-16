//
//  AddMedicineView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 26/08/2025.
//

import SwiftUI

struct AddMedicineView: View {
    @StateObject var addMedicinesVM: AddMedicineViewModel
    @EnvironmentObject var session: SessionStore
    @Environment(\.dismiss) var dismiss
    
    @State private var isPresentingAislePicker = false
    var body: some View {
        Form {
            Section {
                TextField("Medicine name", text: $addMedicinesVM.name)
                HStack {
                    Text("Aisle")
                    Spacer()
                    Text(addMedicinesVM.aisle)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isPresentingAislePicker.toggle()
                    }
                }
                
                if isPresentingAislePicker {
                    AislePickerView(selectedAisle: $addMedicinesVM.aisle, in: addMedicinesVM.aisles)
                }
                
            }
            Section("Stock") {
                TextField("Stock", value: $addMedicinesVM.stock, format: .number)
                TextField("Normal stock", value: $addMedicinesVM.normalStock, format: .number)
                TextField("Warning stock", value: $addMedicinesVM.warningStock, format: .number)
                TextField("Alert stock", value: $addMedicinesVM.alertStock, format: .number)
            }
        }
        .listRowBackground(Color.customPrimary)
        .scrollContentBackground(.hidden)
        .background {
            Color.background
                .ignoresSafeArea()
        }
        .alert("Medication already exists",
               isPresented: $addMedicinesVM.showAlert) {
            Button("Cancel", role: .cancel) { }
            
            Button("Add anyway") {
                Task {
                    await addMedicinesVM.addMedicine(user: session.session?.email ?? "", tryAnyway: true)
                    if addMedicinesVM.error == nil && addMedicinesVM.showAlert == false {
                        dismiss()
                    }
                }
            }
        } message: {
            Text("This medication is already in the list. Would you like to add it anyway ?")
        }
        .navigationTitle("Add medicine")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await addMedicinesVM.fetchAisles()
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
                Button("Add") {
                    Task {
                        await addMedicinesVM.addMedicine(user: session.session?.email ?? "")
                        if addMedicinesVM.error == nil && addMedicinesVM.showAlert == false {
                            dismiss()
                        }
                    }
                }
                .disabled(addMedicinesVM.shouldDisabled)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Add button")
                .accessibilityHint(addMedicinesVM.shouldDisabled ? "Button disabled, fill in all fields" : "Double-tap to add medicines")
                .accessibilityIdentifier("addMedicineButton")
            }
        }
    }
}

#Preview {
    let session = SessionStore()
    NavigationStack {
        AddMedicineView(addMedicinesVM: AddMedicineViewModel())
            .environmentObject(session)
    }
}
