//
//  AuthRepository.swift
//  MediStock
//
//  Created by Thibault Giraudon on 26/08/2025.
//

import Foundation
import FirebaseAuth

class AuthRepository {
//    private let auth = Auth.auth()
    var handle: AuthStateDidChangeListenerHandle?

    func listen() -> User? {
        var loggedUser: User? = nil
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                loggedUser = User(uid: user.uid, email: user.email)
            }
        }
                
        return loggedUser
    }

    func signUp(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        
        return User(uid: result.user.uid, email: result.user.email)
    }

    func signIn(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        
        return User(uid: result.user.uid, email: result.user.email)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    private func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
