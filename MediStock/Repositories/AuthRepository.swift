//
//  AuthRepository.swift
//  MediStock
//
//  Created by Thibault Giraudon on 26/08/2025.
//

import Foundation
import FirebaseAuth

class AuthRepository {
    @Published var currentUser: User? = nil
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        listen()
    }

    private func listen() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            guard let self = self else { return }
            if let user = user {
                self.currentUser = User(uid: user.uid, email: user.email)
            } else {
                self.currentUser = nil
            }
        }
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
