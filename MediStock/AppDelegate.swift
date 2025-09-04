//
//  AppDelegate.swift
//  MediStock
//
//  Created by Vincent Saluzzo on 28/05/2024.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        let env = ProcessInfo.processInfo.environment
        let isUnitTest = env["XCTestConfigurationFilePath"] != nil
        let isUITest = env["-useFirebaseEmulator"] == "YES" || ProcessInfo.processInfo.arguments.contains("-useFirebaseEmulator")

        if isUnitTest || isUITest {
            Auth.auth().useEmulator(withHost: "localhost", port: 9000)
            Firestore.firestore().useEmulator(withHost: "localhost", port: 9010)
            Storage.storage().useEmulator(withHost: "localhost", port: 9020)
            let settings = Firestore.firestore().settings
            settings.cacheSettings = MemoryCacheSettings()
            Firestore.firestore().settings = settings
        }
        
        return true
    }
}
