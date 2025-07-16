//
//  MyMoneyView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 15/07/25.
//

import SwiftUI

struct MyMoneyView: View {
    @State private var balance: Double = 12547.50
    @State private var showingAddAccount = false
    @State private var showingAddCard = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Wallet Balance Card
                    walletBalanceCard
                    
                    // Bank Accounts Section
                    bankAccountsSection
                    
                    // Cards Section
                    cardsSection
                    
                    // Settings Section
                    settingsSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
            .background(Color.lightGreen.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text("My Money")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundColor(.primaryGreen)
                    .padding(12)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.top, 10)
    }
    
    private var walletBalanceCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("WeePay Balance")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("₹\(balance, specifier: "%.2f")")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Image(systemName: "wallet.pass.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                        Text("Add Money")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.primaryGreen)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .clipShape(Capsule())
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title3)
                        Text("Send Money")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Capsule())
                }
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.primaryGreen, Color.accentGreen]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .primaryGreen.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    private var bankAccountsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Bank Accounts")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button("Add Account") {
                    showingAddAccount = true
                }
                .font(.subheadline)
                .foregroundColor(.primaryGreen)
            }
            
            VStack(spacing: 12) {
                BankAccountRow(
                    bankName: "HDFC Bank",
                    accountNumber: "****1234",
                    accountType: "Savings",
                    isDefault: true
                )
                
                BankAccountRow(
                    bankName: "State Bank of India",
                    accountNumber: "****5678",
                    accountType: "Current",
                    isDefault: false
                )
            }
        }
    }
    
    private var cardsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Cards")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button("Add Card") {
                    showingAddCard = true
                }
                .font(.subheadline)
                .foregroundColor(.primaryGreen)
            }
            
            VStack(spacing: 12) {
                CardRow(
                    cardName: "HDFC Credit Card",
                    cardNumber: "****1234",
                    cardType: "Visa",
                    expiryDate: "12/26"
                )
                
                CardRow(
                    cardName: "SBI Debit Card",
                    cardNumber: "****5678",
                    cardType: "Mastercard",
                    expiryDate: "08/25"
                )
            }
        }
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                SettingsRow(icon: "shield.fill", title: "Security", subtitle: "PIN, Face ID, Touch ID")
                SettingsRow(icon: "bell.fill", title: "Notifications", subtitle: "Transaction alerts")
                SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support", subtitle: "FAQs, Contact us")
                SettingsRow(icon: "info.circle.fill", title: "About", subtitle: "Version, Terms & Conditions")
            }
        }
    }
}

struct BankAccountRow: View {
    let bankName: String
    let accountNumber: String
    let accountType: String
    let isDefault: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.primaryGreen.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "building.columns.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.primaryGreen)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(bankName)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text("\(accountNumber) • \(accountType)")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            if isDefault {
                Text("Default")
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.primaryGreen.opacity(0.1))
                    .foregroundColor(.primaryGreen)
                    .clipShape(Capsule())
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct CardRow: View {
    let cardName: String
    let cardNumber: String
    let cardType: String
    let expiryDate: String
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.accentGreen.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.accentGreen)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(cardName)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text("\(cardNumber) • \(cardType)")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                
                Text("Expires \(expiryDate)")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct SettingsRow: View {
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
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    MyMoneyView()
}
