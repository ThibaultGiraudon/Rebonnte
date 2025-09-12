//
//  CustomFields.swift
//  MediStock
//
//  Created by Thibault Giraudon on 12/09/2025.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    var label: String
    @Binding var text: String
    var prompt: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .accessibilityHidden(true)
            TextField(prompt, text: $text)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.1))
                }
        }
    }
}

struct CustomSecureField: View {
    var label: String
    @Binding var text: String
    var prompt: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
            SecureField(prompt, text: $text)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.1))
                }
        }
    }
}
