//
//  HomeView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 15/07/25.
//

import SwiftUI

struct HomeView: View {
    @State private var balance: Double = 12547.50
    @State private var showingSendMoney = false
    @State private var showingCheckBalance = false
    @State private var showingAddMoney = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    headerSection
                    
                    // Balance Card
                    balanceCard
                    
                    // Action Card Panel
                    actionCardPanel
                    
                    // Quick Actions
                    quickActionsSection
                    
                    // Recent Transactions Preview
                    recentTransactionsSection
                    
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
            VStack(alignment: .leading, spacing: 4) {
                Text("Good Morning")
                    .font(.title2)
                    .foregroundColor(.textSecondary)
                
                Text("Anshuman")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell.fill")
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
    
    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Current Balance")
                    .font(.headline)
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                Image(systemName: "eye.slash")
                    .font(.title3)
                    .foregroundColor(.primaryGreen)
            }
            
            Text("₹\(balance, specifier: "%.2f")")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.textPrimary)
        }
        .padding(24)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var actionCardPanel: some View {
        VStack(spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                // Send Money Button
                ActionButton(
                    title: "Send Money",
                    subtitle: "Transfer to phone number",
                    icon: "paperplane.fill",
                    backgroundColor: .primaryGreen,
                    action: { showingSendMoney = true }
                )
                
                // Check Balance Button
                ActionButton(
                    title: "Check Balance",
                    subtitle: "View account balance",
                    icon: "creditcard.fill",
                    backgroundColor: .accentGreen,
                    action: { showingCheckBalance = true }
                )
                
                // Add Money Button
                ActionButton(
                    title: "Add Money",
                    subtitle: "Top up your wallet",
                    icon: "plus.circle.fill",
                    backgroundColor: .mintGreen,
                    textColor: .accentGreen,
                    action: { showingAddMoney = true }
                )
            }
        }
        .padding(20)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("More Actions")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                QuickActionItem(icon: "qrcode", title: "Scan QR", color: .primaryGreen)
                QuickActionItem(icon: "phone.fill", title: "Mobile Recharge", color: .accentGreen)
                QuickActionItem(icon: "bolt.fill", title: "Electricity", color: .warningOrange)
                QuickActionItem(icon: "car.fill", title: "Fuel", color: .primaryGreen)
                QuickActionItem(icon: "tv.fill", title: "DTH", color: .accentGreen)
                QuickActionItem(icon: "ellipsis", title: "More", color: .textSecondary)
            }
        }
    }
    
    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Transactions")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button("View All") {
                    // Navigate to history
                }
                .foregroundColor(.primaryGreen)
                .font(.subheadline)
            }
            
            VStack(spacing: 12) {
                TransactionRow(
                    title: "Rahul Sharma",
                    subtitle: "Money sent",
                    amount: "-₹500.00",
                    time: "2 hours ago",
                    isDebit: true
                )
                
                TransactionRow(
                    title: "Salary Credit",
                    subtitle: "Bank transfer",
                    amount: "+₹25,000.00",
                    time: "Yesterday",
                    isDebit: false
                )
                
                TransactionRow(
                    title: "Priya Patel",
                    subtitle: "Money received",
                    amount: "+₹1,200.00",
                    time: "2 days ago",
                    isDebit: false
                )
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
        }
    }
}

struct ActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let backgroundColor: Color
    var textColor: Color = .white
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(textColor)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(textColor)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(textColor.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(textColor.opacity(0.7))
            }
            .padding(20)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct QuickActionItem: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct TransactionRow: View {
    let title: String
    let subtitle: String
    let amount: String
    let time: String
    let isDebit: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(isDebit ? Color.errorRed.opacity(0.1) : Color.primaryGreen.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: isDebit ? "arrow.up.right" : "arrow.down.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isDebit ? .errorRed : .primaryGreen)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(amount)
                    .font(.headline)
                    .foregroundColor(isDebit ? .errorRed : .primaryGreen)
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

#Preview {
    HomeView()
}
