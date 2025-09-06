//
//  ServiceViews.swift
//  WeePay
//
//  Created by Preview Stub Bundle
//

import SwiftUI

// MARK: - Metro Ticket View
struct MetroTicketView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tram.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentGreen)
            
            Text("Metro Ticket Booking")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text("Coming Soon!")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.lightGreen.ignoresSafeArea())
        .navigationTitle("Metro Ticket")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Electricity Bill View
struct ElectricityBillView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 60))
                .foregroundColor(.warningOrange)
            
            Text("Pay Electricity Bill")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text("Coming Soon!")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.lightGreen.ignoresSafeArea())
        .navigationTitle("Electricity Bill")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Credit Debt View
struct CreditDebtView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "creditcard.fill")
                .font(.system(size: 60))
                .foregroundColor(.primaryGreen)
            
            Text("Pay Credit Card Bill")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text("Coming Soon!")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.lightGreen.ignoresSafeArea())
        .navigationTitle("Credit Card Bill")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Metro Ticket") {
    NavigationStack {
        MetroTicketView()
    }
}

#Preview("Electricity Bill") {
    NavigationStack {
        ElectricityBillView()
    }
}

#Preview("Credit Debt") {
    NavigationStack {
        CreditDebtView()
    }
}
