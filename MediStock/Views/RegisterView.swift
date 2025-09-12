//
//  RegisterView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 01/09/2025.
//

import SwiftUI

struct RegisterView: View {
    @State private var fullname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var coordinator: AppCoordinator
    
    var shouldDisabled: Bool {
        fullname.isEmpty || email.isEmpty || password.isEmpty
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("icon")
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            CustomTextField(label: "Fullname", text: $fullname, prompt: "Enter fullname")
                .keyboardType(.default)
            
            CustomTextField(label: "Email", text: $email, prompt: "Enter email")
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            
            CustomSecureField(label: "Password", text: $password, prompt: "Enter password")
                .textInputAutocapitalization(.never)
            
            CustomButton(title: "Create", color: .lightBlue) {
                Task {
                    await session.signUp(fullname: fullname, email: email, password: password)
                    if session.error == nil {
                        coordinator.dismiss()
                    }
                }
            }
            .opacity(shouldDisabled ? 0.6 : 1)
            .disabled(shouldDisabled)
            .padding(.top)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Create an account button")
            .accessibilityHint(shouldDisabled ? "Button disabled, fill in all fields" : "Double-tap to create an account")
            
            Spacer()
            Spacer()
        }
        .padding()
        .foregroundStyle(.primaryText)
        .background {
            Color.background
                .ignoresSafeArea()
        }
        .overlay(alignment: .bottom) {
            if let error = session.error {
                Text(error)
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundStyle(.white)
                    .accessibilityHidden(true)
                    .onAppear {
                        UIAccessibility.post(notification: .announcement, argument: error)
                    }
            }
        }
    }
}

#Preview {
    let session = SessionStore()
    RegisterView()
        .environmentObject(session)
}
