//
//  AddMedicineView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 26/08/2025.
//

import SwiftUI

struct AddMedicineView: View {
    @StateObject var viewModel = AddMedicineViewModel()
    @EnvironmentObject var session: SessionStore
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Section {
                TextField("Medicine name", text: $viewModel.name)
                TextField("Aisle name", text: $viewModel.aisle)
            }
            Section {
                TextField("Stock", value: $viewModel.stock, format: .number)
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
                        await viewModel.addMedicine(user: session.session?.email ?? "")
                    }
                }
                .disabled(viewModel.shouldDisabled)
            }
        }
    }
}

#Preview {
    let session = SessionStore()
    AddMedicineView()
        .environmentObject(session)
}
