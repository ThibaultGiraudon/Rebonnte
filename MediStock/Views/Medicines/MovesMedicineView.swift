//
//  MovesMedicineView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 17/09/2025.
//

import SwiftUI

struct MovesMedicineView: View {
    @State var medicine: Medicine
    
    @ObservedObject var aislesVM: AislesViewModel
    @ObservedObject var medicinesVM: MedicineStockViewModel
    
    @State private var selectedAisle: String = ""
    @State private var isShowingAislePicker: Bool = false
    
    @EnvironmentObject var session: SessionStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("Move \(medicine.name) from \(medicine.aisle)")
                .font(.title)
            Text("to \(selectedAisle)")
                .foregroundStyle(.lightBlue)
                .onTapGesture {
                    withAnimation {
                        isShowingAislePicker.toggle()
                    }
                }
            .font(.title)
            if isShowingAislePicker {
                    AislePickerView(selectedAisle: $selectedAisle, in: medicinesVM.aisles)
            }
            CustomButton(title: "Save", color: .lightBlue) {
                Task {
                    medicine.aisle = selectedAisle
                    await medicinesVM.updateMedicine(medicine, user: session.session?.email ?? "")
                    dismiss()
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                selectedAisle = medicine.aisle
                await medicinesVM.fetchAisles()
            }
        }
    }
}

#Preview {
    MovesMedicineView(
        medicine: Medicine(name: "Test", stock: 33, aisle: "test", normalStock: 60, warningStock: 20, alertStock: 10, icon: "pills", color: "000000"),
        aislesVM: AislesViewModel(),
        medicinesVM: MedicineStockViewModel())
    .environmentObject(SessionStore())
}
