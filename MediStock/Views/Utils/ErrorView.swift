//
//  ErrorView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 30/08/2025.
//

import SwiftUI

struct ErrorView: View {
    var error: String
    var tryAgain: () -> Void
    
    var body: some View {
        VStack {
            Group {
                Image(systemName: "exclamationmark")
                    .foregroundStyle(.customPrimary)
                    .font(.largeTitle)
                    .padding(20)
                    .background {
                        Circle()
                            .fill(.primaryText)
                    }
                    .padding(.bottom, 24)
            
                Text("Error")
                    .font(.title2.bold())
                    .padding(.bottom, 5)
                Text("An error has occured while:")
                Text(error)
                    .bold()
                Text("please try again later")
            }
            .accessibilityHidden(true)
            .accessibilityValue("An error has occured while \(error)")
            
            Button(action: tryAgain) {
                Text("Try again")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.lightBlue)
                    }
            }
            .foregroundStyle(.white)
            .padding(.top, 35)
            .accessibilityElement()
            .accessibilityHint("Double-tap to try again")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.primaryText)
        .background {
            Color.background
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ErrorView(error: "creating a new medicines") { }
}
