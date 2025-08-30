import Foundation
import Combine
import SwiftUI

@MainActor
class SessionStore: ObservableObject {
    @Published var session: User?
    @Published private(set) var uid: String?
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private var authRepository: AuthRepository = .init()
    private var firestoreRepository: FirestoreRepository = .init()
    private var storageRepository: StorageRepository = .init()

    func signUp(email: String, password: String) async {
        self.error = nil
        do {
            self.uid = try await authRepository.signUp(email: email, password: password)
            guard let uid else {
                self.error = "signing up"
                return
            }
            let user = User(uid: uid, email: email, fullname: "New user")
            try await firestoreRepository.addUser(user)
            self.session = user
        } catch {
            self.error = "signing up"
        }
    }

    func signIn(email: String, password: String) async {
        self.error = nil
        do {
            self.uid = try await authRepository.signIn(email: email, password: password)
            self.session = await self.fetchUser(with: self.uid)
        } catch {
            self.error = "signing in"
        }
    }

    func signOut() {
        self.error = nil
        do {
            try authRepository.signOut()
            self.session = nil
            self.uid = nil
        } catch {
            self.error = "signing out"
        }
    }
    
    func fetchUser(with uid: String?) async -> User? {
        self.error = nil
        guard let uid = uid else {
            self.error = "User not logged in"
            return nil
        }
                
        do {
            return try await firestoreRepository.fetchUser(with: uid)
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
        user.fullname = fullname
        do {
            try await firestoreRepository.updateUser(user)
            self.session = user
        } catch {
            self.error = "updating user's personnal information"
        }
        self.isLoading = false
    }
    
    func uploadImage(_ image: UIImage) async {
        guard var user = session else {
            self.error = "User not logged in"
            return
        }
        self.isLoading = true
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
        self.isLoading = false
    }
    
}

struct User {
    var uid: String
    var email: String
    var fullname: String
    var imageURL: String
    
    init() {
        self.uid = UUID().uuidString
        self.email = ""
        self.fullname = ""
        self.imageURL = ""
    }
    
    init(uid: String, email: String, fullname: String, imageURL: String = "") {
        self.uid = uid
        self.email = email
        self.fullname = fullname
        self.imageURL = imageURL
    }
    
    init?(_ data: [String: Any]?, id: String) {
        guard let data, let email = data["email"] as? String,
              let uid = data["uid"] as? String,
              let fullname = data["fullname"] as? String,
              let imageURL = data["imageURL"] as? String
        else {
            print("failed to get data")
            return nil
        }
        
        self.uid = uid
        self.email = email
        self.fullname = fullname
        self.imageURL = imageURL
    }
    
    func data() -> [String: Any] {
        let data: [String: Any] = [
            "uid": self.uid,
            "email": self.email,
            "fullname": self.fullname,
            "imageURL": self.imageURL
        ]
        
        return data
    }
    
}
