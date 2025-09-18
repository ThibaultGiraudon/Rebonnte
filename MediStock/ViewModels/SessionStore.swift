import Foundation
import Combine
import SwiftUI

/// Represents the authentication state of the user session.
enum AuthenticationState: Hashable {
    /// User is authenticated and signed in.
    case signedIn
    
    /// User is not authenticated and signed out.
    case signedOut
}

/// Stores and manages the user session, authentication state, and profile updates.
///
/// `SessionStore` centralizes all authentication-related operations:
/// - Signing up and signing in users.
/// - Signing out.
/// - Fetching user details from Firestore.
/// - Updating profile information.
/// - Uploading and managing profile pictures.
///
@MainActor
class SessionStore: ObservableObject {
    
    // MARK: - Published Properties
    
    /// The currently signed-in user session.
    @Published var session: User?
    
    /// The unique identifier (UID) of the signed-in user.
    @Published private(set) var uid: String?
    
    /// Indicates whether an async operation (e.g. login, update) is in progress.
    @Published var isLoading: Bool = false
    
    /// An optional error message when an operation fails.
    @Published var error: String?
    
    /// The current authentication state.
    @Published var authenticationState: AuthenticationState = .signedOut
    
    // MARK: - Private Properties
    
    private var authRepository: AuthRepositoryInterface
    private var firestoreRepository: FirestoreRepositoryInterface
    private var storageRepository: StorageRepositoryInterface
    
    // MARK: - Initialization
    
    /// Creates a new `SessionStore` with the given repositories.
    ///
    /// - Parameters:
    ///   - authRepository: Repository for authentication operations (default: `AuthRepository`).
    ///   - firestoreRepository: Repository for user data management (default: `FirestoreRepository`).
    ///   - storageRepository: Repository for image storage (default: `StorageRepository`).
    init(
        authRepository: AuthRepositoryInterface = AuthRepository(),
        firestoreRepository: FirestoreRepositoryInterface = FirestoreRepository(),
        storageRepository: StorageRepositoryInterface = StorageRepository()
    ) {
        self.authRepository = authRepository
        self.firestoreRepository = firestoreRepository
        self.storageRepository = storageRepository
    }

    // MARK: - Authentication
    
    /// Creates a new account and stores the user in Firestore.
    ///
    /// - Parameters:
    ///   - fullname: The full name of the new user.
    ///   - email: The email address of the new user.
    ///   - password: The password for the account.
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

    /// Signs in an existing user with email and password.
    ///
    /// - Parameters:
    ///   - email: The user's email.
    ///   - password: The user's password.
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

    /// Signs out the current user.
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
    
    // MARK: - User Management
    
    /// Fetches the user document from Firestore.
    ///
    /// - Parameter uid: The unique identifier of the user.
    /// - Returns: A `User` object or `nil` if fetching fails.
    private func fetchUser(with uid: String?) async -> User? {
        self.error = nil
        do {
            return try await firestoreRepository.fetchUser(with: uid!)
        } catch {
            self.error = "fetching user's personal information"
            return nil
        }
    }
    
    /// Updates the currently signed-in user's full name.
    ///
    /// - Parameter fullname: The new full name of the user.
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
            self.error = "updating user's personal information"
        }
    }
    
    /// Uploads a new profile image for the user.
    ///
    /// - Parameter image: The image to upload.
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
