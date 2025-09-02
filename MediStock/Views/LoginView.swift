import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var session: SessionStore

    var shouldDisable: Bool {
        email.isEmpty || password.isEmpty
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Image("icon")
                .resizable()
                .scaledToFit()
            
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
            CustomButton(title: "Create an account", color: .darkBlue) {
                Task {
//                    await session.signUp(email: email, password: password)
                    // TODO: add navlink
                }
            }
            .opacity(shouldDisable ? 0.8 : 1)
            .disabled(shouldDisable)
            Spacer()
            Spacer()
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
                .font(.title)
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
