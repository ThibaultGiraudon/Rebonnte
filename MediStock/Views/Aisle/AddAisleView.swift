//
//  AddAisleView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 16/09/2025.
//

import SwiftUI

struct AddAisleView: View {
    @ObservedObject var addAisleVM: AddAisleViewModel
    
    @State private var showIconPicker: Bool = false
    @State private var color: Color = .blue
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: addAisleVM.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48)
                .foregroundStyle(addAisleVM.color.toColor())
                .padding(20)
                .background {
                    Circle()
                        .fill(addAisleVM.color.toColor().opacity(0.2))
                }
                .accessibilityLabel("Aisle icon")
                .accessibilityValue("\(addAisleVM.icon) color: \(addAisleVM.color)")
            Form {
                TextField("Aisle name", text: $addAisleVM.name)
                
                HStack {
                    Text("Icon")
                    Spacer()
                    Image(systemName: addAisleVM.icon)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    showIconPicker.toggle()
                }
                .accessibilityLabel("show icon picker button")
                .accessibilityValue("Selected icon: \(addAisleVM.icon)")
                .accessibilityHint("Double-tap to select an icon to show picker")
                
                if showIconPicker {
                    IconPickerView(selectedIcon: $addAisleVM.icon)
                }
                ColorPicker("Select color", selection: $color)
                    .onChange(of: color) {
                        addAisleVM.color = color.toHex() ?? "6495ED"
                    }
            }
            .navigationTitle("Add aisle")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(addAisleVM.isLoading)
                    .accessibilityLabel("Cancel button")
                    .accessibilityHint("Double-tap to cancel")
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        Task {
                            await addAisleVM.addAisle()
                            dismiss()
                        }
                    }
                    .disabled(addAisleVM.isLoading || addAisleVM.name.isEmpty)
                    .accessibilityLabel(addAisleVM.isLoading ? "Adding..." : "Add aisle")
                    .accessibilityHint(addAisleVM.name.isEmpty ? "Button disabled fill in all fields" : "Double-tap to add aisle")
                }
            }
        }
    }
}

#Preview {
    AddAisleView(addAisleVM: AddAisleViewModel())
}
