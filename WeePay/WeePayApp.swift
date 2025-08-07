//
//  WeePayApp.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 15/07/25.
//

import SwiftUI
import FirebaseCore

@main
struct WeePayApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared
    @StateObject private var authStateManager = AuthStateManager()

    var body: some Scene {
        WindowGroup {
            Group {
                if authStateManager.isAuthenticated {
                    MainTabView()
                } else {
                    AuthView()
                }
            }
            .environmentObject(authStateManager)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
