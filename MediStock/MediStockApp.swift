//
//  MediStockApp.swift
//  MediStock
//
//  Created by Vincent Saluzzo on 28/05/2024.
//

import SwiftUI

@main
struct MediStockApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        lazy var sessionStore = SessionStore()
        lazy var coordinator = AppCoordinator()
        WindowGroup {
            ContentView()
                .environmentObject(sessionStore)
                .environmentObject(coordinator)
        }
    }
}
