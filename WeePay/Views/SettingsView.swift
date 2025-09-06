//
//  SettingsView.swift
//  WeePay
//
//  Created by Preview Stub
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .padding(.top, 20)
                
                VStack(spacing: 16) {
                    SettingSection(title: "Account") {
                        SettingRow(icon: "person.fill", title: "Profile", subtitle: "Manage your account")
                        SettingRow(icon: "shield.fill", title: "Security", subtitle: "PIN, Face ID, Touch ID")
                        SettingRow(icon: "creditcard.fill", title: "Payment Methods", subtitle: "Cards and bank accounts")
                    }
                    
                    SettingSection(title: "Notifications") {
                        SettingRow(icon: "bell.fill", title: "Push Notifications", subtitle: "Transaction alerts")
                        SettingRow(icon: "envelope.fill", title: "Email Notifications", subtitle: "Account updates")
                    }
                    
                    SettingSection(title: "Support") {
                        SettingRow(icon: "questionmark.circle.fill", title: "Help Center", subtitle: "Get help and support")
                        SettingRow(icon: "phone.fill", title: "Contact Us", subtitle: "Reach out to our team")
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .background(Color.lightGreen.ignoresSafeArea())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 16)
            
            VStack(spacing: 1) {
                content
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.primaryGreen)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(.textSecondary)
            }
            .padding(16)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
