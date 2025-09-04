//
//  AuthRepositoryFake.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import Foundation
@testable import MediStock

class AuthRepositoryFake: AuthRepositoryInterface {
    var uid: String?
    var errorString: String = ""
    var error: Error?
    func signUp(email: String, password: String) async throws -> String? {
        if let error {
            throw error
        }
        return uid
    }
    
    func signIn(email: String, password: String) async throws -> String? {
        if let error {
            throw error
        }
        return uid
    }
    
    func signOut() throws {
        if let error {
            throw error
        }
    }
    
    func identifyError(_ error: any Error) -> String {
        return errorString
    }
    
    
}
