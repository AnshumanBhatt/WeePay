//
//  WeePayApp.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 15/07/25.
//

import SwiftUI

@main
struct WeePayApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
