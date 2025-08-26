import Foundation

@MainActor
class SessionStore: ObservableObject {
    @Published var session: User?
    private var authRepository: AuthRepository
    
    init(repository: AuthRepository = .init()) {
        self.authRepository = repository
        
        repository.$currentUser
            .receive(on: DispatchQueue.main)
            .assign(to: &$session)
    }

    func signUp(email: String, password: String) async {
        do {
            self.session = try await authRepository.signUp(email: email, password: password)
        } catch {
            print("An error occured while signing up user: \(error)")
        }
    }

    func signIn(email: String, password: String) async {
        do {
            self.session = try await authRepository.signIn(email: email, password: password)
        } catch {
            print("An error occured while signing in user: \(error)")
        }
    }

    func signOut() {
        do {
            try authRepository.signOut()
            self.session = nil
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

struct User {
    var uid: String
    var email: String?
}
