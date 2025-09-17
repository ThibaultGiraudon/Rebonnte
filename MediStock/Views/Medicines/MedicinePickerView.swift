//
//  MedicinePickerView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 17/09/2025.
//

import SwiftUI

struct MedicinePickerView: View {
    let medicines: [Medicine]
    @Binding var selectedMedicine: Medicine?
    
    @State private var searchText: String = ""
    var filteredMedicines: [Medicine] {
        medicines.filter {
            searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased())
        }
    }
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $searchText)
                
                if !searchText.isEmpty {
                    Image(systemName: "xmark.circle.fill")
                        .onTapGesture {
                            searchText = ""
                        }
                }
            }
            .padding(5)
            .background {
                Capsule().stroke()
            }
            .foregroundStyle(.gray)
            .padding(.bottom)
            ScrollView {
                ForEach(filteredMedicines) { medicine in
                    MedicineRowView(medicine: medicine)
                        .onTapGesture {
                            selectedMedicine = medicine
                        }
                }
            }
        }
        .padding()
    }
}

#Preview {
    MedicinePickerView(medicines: [], selectedMedicine: .constant(nil))
}
