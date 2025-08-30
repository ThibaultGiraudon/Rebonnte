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
    var body: some View {
        Form {
            Section {
                TextField("Medicine name", text: $addMedicinesVM.name)
                TextField("Aisle name", text: $addMedicinesVM.aisle)
            }
            Section {
                TextField("Stock", value: $addMedicinesVM.stock, format: .number)
            }
        }
        .navigationTitle("Add medicine")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add") {
                    Task {
                        await addMedicinesVM.addMedicine(user: session.session?.email ?? "")
                        dismiss()
                    }
                }
                .disabled(addMedicinesVM.shouldDisabled)
            }
        }
    }
}

#Preview {
    let session = SessionStore()
    AddMedicineView(addMedicinesVM: AddMedicineViewModel())
        .environmentObject(session)
}
