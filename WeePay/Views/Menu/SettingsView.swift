//
//  SettingsView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 24/07/25.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject var authStateManager: AuthStateManager
    @State private var showingSignOutAlert = false
    
    var body: some View {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.primaryGreen)
                    
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    if let user = authStateManager.currentUser {
                        Text(user.displayName ?? "User")
                            .font(.headline)
                            .foregroundColor(.textSecondary)
                        
                        Text(user.phoneNumber ?? "No phone")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding(.top, 40)
                .padding(.bottom, 40)
                
                // Settings Options
                VStack(spacing: 16) {
                    SettingRow(icon: "person.circle", title: "Profile", subtitle: "Update your information")
                    SettingRow(icon: "bell", title: "Notifications", subtitle: "Manage notifications")
                    SettingRow(icon: "lock.shield", title: "Privacy & Security", subtitle: "Control your privacy")
                    SettingRow(icon: "questionmark.circle", title: "Help & Support", subtitle: "Get help and support")
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Sign Out Button
                    Button(action: {
                        showingSignOutAlert = true
                    }) {
                        HStack {
                            Image(systemName: "power")
                                .font(.title3)
                                .foregroundColor(.red)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Sign Out")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.leading)
                                
                                Text("Sign out of your account")
                                    .font(.caption)
                                    .foregroundColor(.red.opacity(0.7))
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.red.opacity(0.5))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.red.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                authStateManager.signOut()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.primaryGreen)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    SettingsView()
}
