//
//  AuthRepositoryTests.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 04/09/2025.
//

import XCTest
@testable import MediStock
import FirebaseAuth

final class AuthRepositoryTests: XCTestCase {
    
    func testSignUpAndSignInAndSignOutShouldSucceed() async {
        let email = "user@test.app"
        let password = "12345678"

        let repositoriy = AuthRepository()
        
        do {
            let uid = try await repositoriy.signUp(email: email, password: password)
            XCTAssertFalse(uid.isEmpty)
        } catch {
            XCTFail("Registration failed: \(error)")
        }
        
        do {
            try repositoriy.signOut()
            XCTAssertNil(repositoriy.auth.currentUser)
        } catch {
            XCTFail("Signing out failed: \(error)")
        }
        
        do {
            let uid = try await repositoriy.signIn(email: email, password: password)
            XCTAssertFalse(uid.isEmpty)
        } catch {
            XCTFail("Signg in failed: \(error)")
        }
    }
    
    func testRegisterShouldFailWithBadEmailFormat() async {
        let email = "testuser"
        let password = "testpassword"
        
        let repositoriy = AuthRepository()
        
        do {
            _ = try await repositoriy.signUp(email: email, password: password)
            XCTFail("Registration should failed")
        } catch {
            let nsError = error as NSError
            let authCode = AuthErrorCode(rawValue: nsError.code)
            XCTAssertEqual(authCode, AuthErrorCode.invalidEmail)
        }
    }

    func testSignInShouldFailWithUserNotFound() async {
        let email = "test2@example.com"
        let password = "testpassword"
        
        let repositoriy = AuthRepository()
        
        do {
            _ = try await repositoriy.signIn(email: email, password: password)
            XCTFail("Registration should failed")
        } catch {
            let nsError = error as NSError
            let authCode = AuthErrorCode(rawValue: nsError.code)
            XCTAssertEqual(authCode, AuthErrorCode.userNotFound)
        }
    }
    
    func testIdentifyError() {
        
        let repositoriy = AuthRepository()
        
        XCTAssertEqual(repositoriy.identifyError(AuthErrorCode.networkError), "Internet connection problem.")
        XCTAssertEqual(repositoriy.identifyError(AuthErrorCode.userNotFound), "No account matches this email.")
        XCTAssertEqual(repositoriy.identifyError(AuthErrorCode.wrongPassword), "Incorrect password.")
        XCTAssertEqual(repositoriy.identifyError(AuthErrorCode.invalidCredential), "Incorrect password.")
        XCTAssertEqual(repositoriy.identifyError(AuthErrorCode.emailAlreadyInUse), "This email is already in use.")
        XCTAssertEqual(repositoriy.identifyError(AuthErrorCode.invalidEmail), "Invalid email format.")
        XCTAssertEqual(repositoriy.identifyError(AuthErrorCode.weakPassword), "Password is too weak (minimum 6 characters).")
        XCTAssertEqual(repositoriy.identifyError(AuthErrorCode.tooManyRequests), "Too many attempts. Please try again later.")
        XCTAssertEqual(repositoriy.identifyError(AuthErrorCode.internalError), "An error occurred: \(AuthErrorCode.internalError.rawValue)")
        XCTAssertEqual(repositoriy.identifyError(URLError(.badURL)), "Unknown error: \(URLError(.badURL).localizedDescription)")
    }

}
