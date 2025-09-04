//
//  UserModelTests.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 04/09/2025.
//

import XCTest
@testable import MediStock

final class UserModelTests: XCTestCase {

    func testCreateUserWithInitEmpty() {
        let user = User()
        
        XCTAssertEqual(user.email, "")
        XCTAssertEqual(user.fullname, "")
        XCTAssertEqual(user.imageURL, "")
    }
    
    func testCreateUserWithInitFull() {
        let user = User(uid: "123", email: "user@test.app", fullname: "New user", imageURL: "testurl")
        
        XCTAssertEqual(user.uid, "123")
        XCTAssertEqual(user.email, "user@test.app")
        XCTAssertEqual(user.fullname, "New user")
        XCTAssertEqual(user.imageURL, "testurl")
    }
    
    func testCreateUserWithInitDataShouldSucceed() {
        guard let user = User(FakeData().userData) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(user.uid, "123")
        XCTAssertEqual(user.email, "user@test.app")
        XCTAssertEqual(user.fullname, "New user")
        XCTAssertEqual(user.imageURL, "testurl")
    }
    
    func testCreateUserWithInitDataShouldBeNil() {
        let user = User(FakeData().wrongUserData)
        
        XCTAssertNil(user)
    }
    
    func testUserData() {
        let user = User(uid: "123", email: "user@test.app", fullname: "New user", imageURL: "testurl")
        
        guard let newUser = User(user.data()) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(newUser, user)
    }
}
