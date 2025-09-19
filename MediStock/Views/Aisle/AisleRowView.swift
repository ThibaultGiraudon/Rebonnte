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
        HStack(alignment: .center) {
            Image(systemName: aisle.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding(10)
                .background {
                    Circle()
                        .fill(aisle.color.toColor().opacity(0.2))
                }
                .foregroundStyle(aisle.color.toColor())
            
            VStack(alignment: .leading) {
                Text(aisle.name)
                    .font(.largeTitle)
                    .multilineTextAlignment(.leading)
                
                Text("\(aisle.medicines.count) medicines")
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
        .padding(5)
    }
}

#Preview {
    AisleRowView(aisle: .init(name: "Allergy & Asthma", icon: "pills.fill", color: "B51A00"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
}
