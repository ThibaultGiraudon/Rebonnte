//
//  AislePickerView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 16/09/2025.
//

import SwiftUI

struct AislePickerView: View {
    @Binding var selectedAisle: String
    var aisles: [String]
    
    @State private var searchText: String = ""
    
    private var filteredAisles: [String] {
        aisles.filter { searchText.isEmpty || $0.lowercased().contains(searchText.lowercased()) }
    }
    
    init(selectedAisle: Binding<String>, in aisles: [String]) {
        self._selectedAisle = selectedAisle
        self.aisles = aisles
    }
    
    var body: some View {
        VStack(alignment: .leading) {
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
            
            ScrollView {
                ForEach(filteredAisles, id: \.self) { aisle in
                    HStack {
                        Image(systemName: selectedAisle == aisle ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedAisle == aisle ? .blue : .gray)
                        Text(aisle)
                    }
                    .onTapGesture {
                        selectedAisle = aisle
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedAisle: String = ""
    AislePickerView(selectedAisle: $selectedAisle, in: [
        "Aisle 1",
        "Aisle 2",
    ])
}
