//
//  PreviewContainer.swift
//  WeePay
//
//  Created by AI Assistant on 18/08/25.
//

import SwiftUI
import CoreData

/// A container that provides the proper environment for SwiftUI previews
struct PreviewContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AuthStateManager())
    }
}

extension View {
    /// Wraps a view with the standard preview environment
    func previewEnvironment() -> some View {
        PreviewContainer {
            self
        }
    }
}
