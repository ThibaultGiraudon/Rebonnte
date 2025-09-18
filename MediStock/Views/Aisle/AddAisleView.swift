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
            Form {
                TextField("Aisle name", text: $addAisleVM.name)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                HStack {
                    Text("Icon")
                    Spacer()
                    Image(systemName: addAisleVM.icon)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    showIconPicker.toggle()
                }
                
                if showIconPicker {
                    IconPickerView(selectedIcon: $addAisleVM.icon)
                }
                ColorPicker("Select color", selection: $color)
                    .onChange(of: color) {
                        addAisleVM.color = color.toHex() ?? "6495ED"
                    }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        Task {
                            await addAisleVM.addAisle()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddAisleView(addAisleVM: AddAisleViewModel())
}
