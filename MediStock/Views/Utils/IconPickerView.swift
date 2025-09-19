//
//  IconPickerView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 16/09/2025.
//

import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    let icons: [String] = Bundle.main.decode("symbols")
    @State private var searchText: String = ""
    var filteredIcons: [String] {
        icons.filter { searchText.isEmpty || $0.contains(searchText.lowercased()) }
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
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Erase search button")
                        .accessibilityHint("Double tap to erase search")
                }
            }
            .padding(5)
            .background {
                Capsule().stroke()
            }
            .foregroundStyle(.gray)
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(), count: 7)) {
                    ForEach(filteredIcons, id: \.self) { icon in
                        Image(systemName: icon)
                            .font(.title)
                            .onTapGesture {
                                selectedIcon = icon
                            }
                            .foregroundStyle(selectedIcon == icon ? .lightBlue : .primaryText)
                            .accessibilityHint("Double tap to select")
                            .accessibilityLabel("\(selectedIcon == icon ? "Selected " : "") \(icon)")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 200)
        }
    }
}

#Preview {
    @Previewable @State var selectedIcon: String = "pills.fill"
    IconPickerView(selectedIcon: $selectedIcon)
}
