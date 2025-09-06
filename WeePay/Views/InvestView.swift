//
//  InvestView.swift
//  WeePay
//
//  Created by Preview Stub
//

import SwiftUI

struct InvestView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Invest & Grow")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    Text("Build wealth with smart investment options")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Investment Options
                VStack(spacing: 16) {
                    InvestmentOption(
                        title: "Mutual Funds",
                        subtitle: "Start with ₹500",
                        returns: "12-15% returns",
                        icon: "chart.pie.fill",
                        color: .primaryGreen
                    )
                    
                    InvestmentOption(
                        title: "Fixed Deposits",
                        subtitle: "Safe & secure",
                        returns: "6-8% returns",
                        icon: "lock.fill",
                        color: .blue
                    )
                    
                    InvestmentOption(
                        title: "Gold",
                        subtitle: "Digital gold",
                        returns: "8-10% returns",
                        icon: "circle.fill",
                        color: .yellow
                    )
                    
                    InvestmentOption(
                        title: "Stocks",
                        subtitle: "Direct equity",
                        returns: "15-20% returns",
                        icon: "chart.line.uptrend.xyaxis",
                        color: .green
                    )
                }
                .padding(.horizontal, 20)
                
                // Portfolio Summary
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your Portfolio")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: 12) {
                        PortfolioRow(name: "Mutual Funds", value: "₹25,000", change: "+12.5%", isPositive: true)
                        PortfolioRow(name: "Fixed Deposits", value: "₹50,000", change: "+6.2%", isPositive: true)
                        PortfolioRow(name: "Gold", value: "₹15,000", change: "-2.1%", isPositive: false)
                    }
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal, 20)
            }
        }
        .background(Color.lightGreen.ignoresSafeArea())
        .navigationTitle("Invest")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InvestmentOption: View {
    let title: String
    let subtitle: String
    let returns: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(color)
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
                    Text(returns)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(color)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct PortfolioRow: View {
    let name: String
    let value: String
    let change: String
    let isPositive: Bool
    
    var body: some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)
                
                Text(change)
                    .font(.caption)
                    .foregroundColor(isPositive ? .green : .red)
            }
        }
    }
}

#Preview {
    NavigationStack {
        InvestView()
    }
}
