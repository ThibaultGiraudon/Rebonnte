//
//  CustomButton.swift
//  MediStock
//
//  Created by Thibault Giraudon on 12/09/2025.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var color: Color
    var completion: () -> Void
    var body: some View {
        Button {
            completion()
        } label: {
            Text(title)
                .foregroundStyle(.white)
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color)
                }
        }
    }
}
