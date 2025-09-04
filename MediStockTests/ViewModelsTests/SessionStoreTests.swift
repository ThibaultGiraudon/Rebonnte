//
//  SessionStoreTests.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 04/09/2025.
//

import XCTest
@testable import MediStock

final class SessionStoreTests: XCTestCase {

    @MainActor
    func testSignUpShouldSucceed() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        
        authRepoFake.uid = "123"
        
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        
        await session.signUp(fullname: "New user", email: "user@test.app", password: "12345678")
        
        XCTAssertEqual(session.session?.uid, "123")
        XCTAssertEqual(session.authenticationState, .signedIn)
    }

    @MainActor
    func testSignUpShouldFailedInAuth() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        
        authRepoFake.error = FakeData().error
        authRepoFake.errorString = "error creating user"
        
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        
        await session.signUp(fullname: "New user", email: "user@test.app", password: "12345678")
        
        XCTAssertEqual(session.error, "error creating user")
    }

    @MainActor
    func testSignUpShouldFailedInFirestore() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        
        authRepoFake.uid = "123"
        authRepoFake.errorString = "error creating user"
        firestoreRepoFake.userError = FakeData().error
        
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        
        await session.signUp(fullname: "New user", email: "user@test.app", password: "12345678")
        
        XCTAssertEqual(session.error, "error creating user")
    }

    @MainActor
    func testSignUpShouldFailedWithUIDNil() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        
        await session.signUp(fullname: "New user", email: "user@test.app", password: "12345678")
        
        XCTAssertEqual(session.error, "An error occured, please try again.")
    }
    
    @MainActor
    func testSignInShouldSucceed() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        
        authRepoFake.uid = "123"
        firestoreRepoFake.user = FakeData().user
        
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        
        await session.signIn(email: "user@test.app", password: "12345678")
        
        XCTAssertEqual(session.session, FakeData().user)
        XCTAssertEqual(session.uid, "123")
        XCTAssertEqual(session.authenticationState, .signedIn)
    }
    
    @MainActor
    func testSignInShouldFailedInAuth() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        
        authRepoFake.error = FakeData().error
        authRepoFake.errorString = "error signing in user"
        
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        
        await session.signIn(email: "user@test.app", password: "12345678")
        
        XCTAssertEqual(session.error, "error signing in user")
    }
    
    @MainActor
    func testSignInShouldFailedInFirestore() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        
        authRepoFake.uid = "123"
        authRepoFake.errorString = "error signing in user"
        firestoreRepoFake.userError = FakeData().error
        
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        
        await session.signIn(email: "user@test.app", password: "12345678")
        
        XCTAssertEqual(session.error, "fetching user's personnal information")
    }
    
    @MainActor
    func testSignInShouldFailedWithUIDNil() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        
        authRepoFake.errorString = "error signing in user"
        
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        
        await session.signIn(email: "user@test.app", password: "12345678")
        
        XCTAssertEqual(session.error, "An error occured, please try again.")
    }
    
    @MainActor
    func testSignOutShouldSucceed() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        
        authRepoFake.uid = "123"
        firestoreRepoFake.user = FakeData().user
        
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        
        await session.signIn(email: "user@test.app", password: "12345678")
        
        XCTAssertEqual(session.session, FakeData().user)
        XCTAssertEqual(session.uid, "123")
        XCTAssertEqual(session.authenticationState, .signedIn)
        
        session.signOut()
        
        XCTAssertNil(session.session)
        XCTAssertNil(session.uid)
        XCTAssertEqual(session.authenticationState, .signedOut)
    }
    
    @MainActor
    func testSignOutShouldFailed() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        
        authRepoFake.error = FakeData().error
        
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        
        session.signOut()
        
        XCTAssertEqual(session.error, "signing out")
    }
    
    @MainActor
    func testUpdateUserShouldSucceed() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
                
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        session.session = FakeData().user
        
        await session.updateUser(fullname: "Charles Leclerc")
        
        XCTAssertEqual(session.session?.fullname, "Charles Leclerc")
    }
    
    @MainActor
    func testUpdateUserShouldFailedWithUserNotLogged() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
                
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        
        await session.updateUser(fullname: "Charles Leclerc")
        
        XCTAssertEqual(session.error, "User not logged in")
    }
    
    @MainActor
    func testUpdateUserShouldFailedWithError() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        
        firestoreRepoFake.userError = FakeData().error
                
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        session.session = FakeData().user
        
        await session.updateUser(fullname: "Charles Leclerc")
        
        XCTAssertEqual(session.error, "updating user's personnal information")
    }
    
    @MainActor
    func testUploadImageShouldSucceed() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        
        storageRepoFake.imageURL = "https://www.testurl.app"
                
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        session.session = User(uid: "123", email: "user@test.app", fullname: "New user", imageURL: "https://www.anotherurl.app")
        
        guard let uiImage = UIImage(systemName: "plus") else {
            XCTFail()
            return
        }
        
        await session.uploadImage(uiImage)
        
        XCTAssertEqual(session.session?.imageURL, "https://www.testurl.app")
    }
    
    @MainActor
    func testUploadImageShouldFaileddWithUserNotLoggedIn() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        
        storageRepoFake.imageURL = "https://www.testurl.app"
                
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        
        guard let uiImage = UIImage(systemName: "plus") else {
            XCTFail()
            return
        }
        
        await session.uploadImage(uiImage)
        
        XCTAssertEqual(session.error, "User not logged in")
    }
    
    @MainActor
    func testUploadImageShouldFaileddWithError() async {
        let authRepoFake = AuthRepositoryFake()
        let firestoreRepoFake = FirestoreRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        
        storageRepoFake.error = FakeData().error
                
        let session = SessionStore(authRepository: authRepoFake, firestoreRepository: firestoreRepoFake, storageRepository: storageRepoFake)
        session.session = FakeData().user
        
        guard let uiImage = UIImage(systemName: "plus") else {
            XCTFail()
            return
        }
        
        await session.uploadImage(uiImage)
        
        XCTAssertEqual(session.error, "uploading new user's profile picture")
    }
}
