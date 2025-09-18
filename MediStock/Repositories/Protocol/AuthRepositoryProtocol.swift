//
//  AuthRepositoryProtocol.swift
//  MediStock
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import Foundation

/// Interface to manage user authentification state such as register, authenticate or sign out.
/// This protocol allows injection of real or mock repository for testing.
protocol AuthRepositoryInterface {
    
    /// Register a new user on Firebase.
    ///
    /// - Parameters:
    ///   - email: A `String` representing the user's email.
    ///   - password: A `String` representing the user's password.
    /// - Returns: A `String` representing the UID of the logged user.
    /// - Throws: An `Error` if the operation fails.
    func signUp(email: String, password: String) async throws -> String
    
    
    /// Authenticate the user on Firebase.
    ///
    /// - Parameters:
    ///   - email: A `String` representing the user's email.
    ///   - password: A `String` representing the user's password.
    /// - Returns: A `String` representing the UID of the logged user.
    /// - Throws: An `Error` if the operation fails.
    func signIn(email: String, password: String) async throws -> String
    
    /// Signs out the logged user.
    func signOut() throws
    
    /// Converts the Auth error from Firebase in a human readable format.
    ///
    /// - Parameter error: The error to identify.
    func identifyError(_ error: Error) -> String
}
