//
//  MediStockUITests.swift
//  MediStockUITests
//
//  Created by Thibault Giraudon on 04/09/2025.
//

import XCTest

final class MediStockUITests: XCTestCase {

    let email = "tibo@test.com"
    let fullname = "Tibo Giraudon"
    let password = "qwerty132!"
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        resetFirebaseEmulators()
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launchArguments += ["-useFirebaseEmulator", "YES"]
        app.launch()
    }
    
    func test_fullFlow_createAccount_logout_login_addMedicine_checkList() throws {
//        createAccount()
//        XCTAssertTrue(app.staticTexts["profile"].waitForExistence(timeout: 5))
//        
//        logout()
//        XCTAssertTrue(app.buttons["Sign in"].waitForExistence(timeout: 5))
//        
//        login()
//        XCTAssertTrue(app.staticTexts["medicines"].waitForExistence(timeout: 5))
//        
//        addMedicine()
//        XCTAssertTrue(app.staticTexts["Medicine 33"].waitForExistence(timeout: 5))
//        
//        checkMedicine()
//        
//        updateMedicine()
    }
    
    func createAccount() {
        app.buttons["Create an account"].tap()
        
        let emailField = app.textFields["Enter email"]
        let fullnameField = app.textFields["Enter fullname"]
        let passwordField = app.secureTextFields["Enter password"]
        
        emailField.tap()
        emailField.typeText(email)
        
        fullnameField.tap()
        fullnameField.typeText(fullname)
        
        passwordField.tap()
        passwordField.typeText(password)
                
        app.buttons["Create"].tap()
    }
    
    func logout() {
        let profileButton = app.staticTexts["profile"]
        profileButton.tap()
        app.buttons["Log Out"].tap()
    }
    
    func login() {
        let emailField = app.textFields["Enter email"]
        let passwordField = app.secureTextFields["Enter password"]
        
        emailField.tap()
        emailField.typeText(email)
        
        passwordField.tap()
        passwordField.typeText(password)
        
        app.buttons["Sign in"].tap()
    }
    
    func addMedicine() {
        app.staticTexts["medicines"].tap()
        
        app.buttons["Add"].tap()
        
        let medicineNameField = app.textFields["Medicine name"]
        let aisleNameField = app.textFields["Aisle name"]
        let stockField = app.textFields["Stock"]
        
        medicineNameField.tap()
        medicineNameField.typeText("Medicine 33")
        
        aisleNameField.tap()
        aisleNameField.typeText("Aisle 33")
        
        stockField.tap()
        stockField.typeText("33\n")
        
        app.navigationBars["Add medicine"].buttons["Add"].tap()
    }
    
    func checkMedicine() {
        app.staticTexts["aisles"].tap()
        
        app.buttons["Aisle 33"].tap()
        
        app.staticTexts["Medicine 33"].tap()
        
        XCTAssertTrue(app.textFields["Medicine 33"].waitForExistence(timeout: 5))
    }
    
    func updateMedicine() {
        let medicineNameField = app.textFields["Medicine 33"]
        
        medicineNameField.tap()
        medicineNameField.typeText("Medicine 16")
        
        app.buttons["Save"].tap()
    }
    
    private func resetFirebaseEmulators() {
        let projectId = "gestionstockmedicaments-dd197"
        let bucketName = "\(projectId).appspot.com"
        
        let endpoints = [
            "http://localhost:9000/emulator/v1/projects/\(projectId)/accounts",
            "http://localhost:9010/emulator/v1/projects/\(projectId)/databases/(default)/documents",
            "http://localhost:9020/emulator/v1/projects/\(projectId)/buckets/\(bucketName)/o"
        ]
        
        let session = URLSession(configuration: .ephemeral)
        let group = DispatchGroup()
        
        for endpoint in endpoints {
            guard let url = URL(string: endpoint) else { continue }
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            group.enter()
            session.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("⚠️ Error resetting \(endpoint): \(error)")
                } else if let httpResponse = response as? HTTPURLResponse {
                    print("✅ \(endpoint) reset (status: \(httpResponse.statusCode))")
                }
                group.leave()
            }.resume()
        }
        
        group.wait()
    }
}
