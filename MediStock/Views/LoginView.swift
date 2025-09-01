import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var session: SessionStore

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button {
                Task {
                   await session.signIn(email: email, password: password)
                }
            } label: {
                Text("Login")
            }
            .disabled(email.isEmpty || password.isEmpty)
            Button {
                Task {
                   await session.signUp(email: email, password: password)
                }
            } label: {
                Text("Sign Up")
            }
            .disabled(email.isEmpty || password.isEmpty)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(SessionStore())
    }
}
