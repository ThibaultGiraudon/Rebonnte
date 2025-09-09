//
//  LoadingView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 09/09/2025.
//

import SwiftUI

struct LoadingView: View {
    let size: CGSize = .init(width: 50, height: 50)
    let lineWidth: CGFloat = 5
    @State private var lenght: CGFloat = 0.0
    @State private var rotationDegree: CGFloat = 270.0
    var body: some View {
        ZStack {
            Circle()
                .trim(from: lenght + 0.05, to: 1.0)
                .stroke(style: .init(lineWidth: lineWidth, lineCap: .round))
                .fill(.white)
                .frame(width: size.width, height: size.height)
                .rotationEffect(.degrees(rotationDegree))
            
            Circle()
                .trim(from: 0.05, to: lenght)
                .stroke(style: .init(lineWidth: lineWidth, lineCap: .round))
                .fill(.white.opacity(0.5))
                .frame(width: size.width, height: size.height)
                .rotationEffect(.degrees(rotationDegree))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color(.background)
                .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.linear.speed(0.2).repeatForever(autoreverses: false)) {
                lenght = 1.0
                rotationDegree = 630
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Waiting for content to load")
    }
}

#Preview {
    LoadingView()
}
