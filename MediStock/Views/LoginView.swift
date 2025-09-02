import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var coordinator: AppCoordinator

    var shouldDisable: Bool {
        email.isEmpty || password.isEmpty
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Image("icon")
                .resizable()
                .scaledToFit()
                .accessibilityHidden(true)
            
            Spacer()
            
            CustomTextField(label: "Email", text: $email, prompt: "Enter email")
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            
            CustomSecureField(label: "Password", text: $password, prompt: "Enter password")
            
            CustomButton(title: "Sign In", color: .lightBlue) {
                Task {
                   await session.signIn(email: email, password: password)
                }
            }
            .opacity(shouldDisable ? 0.6 : 1)
            .disabled(shouldDisable)
            .padding(.top)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Sign in button")
            .accessibilityHint(shouldDisable ? "Button disabled, fill in all fields" : "Double-tap to sign in")
            
            CustomButton(title: "Create an account", color: .darkBlue) {
                coordinator.goToRegister()
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Create an account button")
            .accessibilityHint("Double-tap to go to create an account page")
            
            Spacer()
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.primaryText)
        .background {
            Color.background
                .ignoresSafeArea()
        }
        .overlay(alignment: .bottom, content: {
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
        })
    }
}

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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(SessionStore())
    }
}
