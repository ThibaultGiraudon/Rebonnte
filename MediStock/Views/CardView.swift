//
//  CardView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 17/09/2025.
//

import SwiftUI

struct CardView: View {
    var icon: String
    var title: String
    var color: Color
    var value: Int
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
                    .padding(10)
                    .background {
                        Circle()
                            .fill(color.opacity(0.2))
                    }
                Text("\(value)")
                    .font(.largeTitle.bold())
                Text(title)
                    .font(.headline)
            }
            Spacer()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.customPrimary)
        }
    }
}

#Preview {
    CardView(icon: "pills", title: "Total medicines", color: .blue, value: 5)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
}
