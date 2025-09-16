//
//  AisleRowView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 16/09/2025.
//

import SwiftUI

struct AisleRowView: View {
    var aisle: Aisle
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: aisle.icon)
                .padding(10)
                .font(.largeTitle)
                .background {
                    Circle()
                        .fill(aisle.color.toColor())
                }
                .foregroundStyle(.customPrimary)
            
            Text(aisle.name)
                .font(.largeTitle)
            
            Text("\(aisle.medicines.count) medicines")
                .font(.title)
        }
        .padding(5)
    }
}

#Preview {
    AisleRowView(aisle: .init(name: "test", icon: "pills.fill", color: "B51A00"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
}
