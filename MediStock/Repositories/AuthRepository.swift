//
//  AuthRepository.swift
//  MediStock
//
//  Created by Thibault Giraudon on 26/08/2025.
//

import Foundation
import FirebaseAuth

class AuthRepository: AuthRepositoryInterface {
    
    let auth = Auth.auth()
    
    func signUp(email: String, password: String) async throws -> String {
        let result = try await auth.createUser(withEmail: email, password: password)
        
        return result.user.uid
    }

    func signIn(email: String, password: String) async throws -> String {
        let result = try await auth.signIn(withEmail: email, password: password)
        
        return result.user.uid
    }

    func signOut() throws {
        try auth.signOut()
    }
    
    /// Translates Firebase Auth errors into user-friendly messages.
    ///
    /// - Parameter error: The error to identify.
    /// - Returns: A string description of the error suitable for display to users.
    func identifyError(_ error: Error) -> String {
        if let errCode = AuthErrorCode(rawValue: (error as NSError).code) {
            switch errCode {
            case .networkError:
                return "Internet connection problem."
            case .userNotFound:
                return "No account matches this email."
            case .wrongPassword, .invalidCredential:
                return "Incorrect password."
            case .emailAlreadyInUse:
                return "This email is already in use."
            case .invalidEmail:
                return "Invalid email format."
            case .weakPassword:
                return "Password is too weak (minimum 6 characters)."
            case .tooManyRequests:
                return "Too many attempts. Please try again later."
            default:
                return "An error occurred: \(errCode.rawValue)"
            }
        }
        return "Unknown error: \(error.localizedDescription)"
    }
}
