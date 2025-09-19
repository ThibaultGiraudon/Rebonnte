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
                    .accessibilityHidden(true)
                TextField("Search", text: $searchText)
                
                if !searchText.isEmpty {
                    Image(systemName: "xmark.circle.fill")
                        .onTapGesture {
                            searchText = ""
                        }
                        .accessibilityLabel("Erase search button")
                        .accessibilityHint("Double-tap to erase search")
                }
            }
            .padding(5)
            .background {
                Capsule().stroke()
            }
            .foregroundStyle(.gray)
            .padding(.bottom)
            ScrollView(showsIndicators: false) {
                ForEach(filteredMedicines) { medicine in
                    MedicineRowView(medicine: medicine)
                        .onTapGesture {
                            selectedMedicine = medicine
                        }
                }
            }
        }
        .padding()
        .background {
            Color.background
                .ignoresSafeArea()
        }
    }
}

#Preview {
    MedicinePickerView(medicines: [], selectedMedicine: .constant(nil))
}
