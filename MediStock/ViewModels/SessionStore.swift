import Foundation
import Combine
import SwiftUI

enum AuthenticationState: Hashable {
    case signedIn
    case signedOut
}

@MainActor
class SessionStore: ObservableObject {
    @Published var session: User?
    @Published private(set) var uid: String?
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var authenticationState: AuthenticationState = .signedOut
    
    private var authRepository: AuthRepositoryInterface
    private var firestoreRepository: FirestoreRepositoryInterface
    private var storageRepository: StorageRepositoryInterface
    
    init(
        authRepository: AuthRepositoryInterface = AuthRepository(),
        firestoreRepository: FirestoreRepositoryInterface = FirestoreRepository(),
        storageRepository: StorageRepositoryInterface = StorageRepository()
    ) {
        self.authRepository = authRepository
        self.firestoreRepository = firestoreRepository
        self.storageRepository = storageRepository
    }

    func signUp(fullname: String, email: String, password: String) async {
        self.error = nil
        
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            self.uid = try await authRepository.signUp(email: trimmedEmail, password: password)
            let user = User(uid: uid!, email: email, fullname: fullname)
            try await firestoreRepository.addUser(user)
            self.session = user
            self.authenticationState = .signedIn
        } catch {
            self.error = authRepository.identifyError(error)
        }
    }

    func signIn(email: String, password: String) async {
        self.error = nil
        
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            self.uid = try await authRepository.signIn(email: trimmedEmail, password: password)
            self.session = await self.fetchUser(with: self.uid)
            self.authenticationState = .signedIn
        } catch {
            self.error = authRepository.identifyError(error)
        }
    }

    func signOut() {
        self.error = nil
        do {
            try authRepository.signOut()
            self.session = nil
            self.uid = nil
            self.authenticationState = .signedOut
        } catch {
            self.error = "signing out"
        }
    }
    
    private func fetchUser(with uid: String?) async -> User? {
        self.error = nil
        
        do {
            return try await firestoreRepository.fetchUser(with: uid!)
        } catch {
            self.error = "fetching user's personnal information"
            return nil
        }
    }
    
    func updateUser(fullname: String) async {
        self.error = nil
        guard var user = session else {
            self.error = "User not logged in"
            return
        }
        
        self.isLoading = true
        defer { self.isLoading = false }
        
        user.fullname = fullname
        do {
            try await firestoreRepository.updateUser(user)
            self.session = user
        } catch {
            self.error = "updating user's personnal information"
        }
    }
    
    func uploadImage(_ image: UIImage) async {
        self.error = nil
        
        guard var user = session else {
            self.error = "User not logged in"
            return
        }
        
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            let currentImageURL = user.imageURL
            let imageURL = try await storageRepository.uploadImage(image, to: "profils_image")
            user.imageURL = imageURL
            try await firestoreRepository.updateUser(user)
            if !currentImageURL.isEmpty {
                try await storageRepository.deleteImage(with: currentImageURL)
            }
            self.session = user
        } catch {
            self.error = "uploading new user's profile picture"
        }
    }
    
}
