//
//  AuthStateManager.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 07/08/25.
//

import SwiftUI
import FirebaseAuth

@MainActor
class AuthStateManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    private var authListener: AuthStateDidChangeListenerHandle?
    
    init() {
        setupAuthListener()
    }
    
    private func setupAuthListener() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    deinit {
        if let listener = authListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
}
