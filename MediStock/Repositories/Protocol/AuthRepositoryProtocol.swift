//
//  AuthRepositoryProtocol.swift
//  MediStock
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import Foundation

protocol AuthRepositoryInterface {
    func signUp(email: String, password: String) async throws -> String
    func signIn(email: String, password: String) async throws -> String
    func signOut() throws
    func identifyError(_ error: Error) -> String
}
