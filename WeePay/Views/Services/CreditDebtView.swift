//
//  CreditDebtView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 24/07/25.
//

import SwiftUI

struct CreditDebtView: View {
    struct CreditCard: Identifiable {
        let id = UUID()
        let bank: String
        let last4: String
        let totalLimit: Double
        let currentDue: Double
        let minDue: Double
        let dueDate: String
        let isPrimary: Bool
    }
    
    private let cards: [CreditCard] = [
        CreditCard(bank: "HDFC Bank", last4: "4821", totalLimit: 150000, currentDue: 42580, minDue: 5200, dueDate: "25 Nov", isPrimary: true),
        CreditCard(bank: "SBI Card", last4: "9934", totalLimit: 100000, currentDue: 18990, minDue: 2300, dueDate: "18 Nov", isPrimary: false),
        CreditCard(bank: "Axis Neo", last4: "7712", totalLimit: 60000, currentDue: 7420, minDue: 900, dueDate: "02 Dec", isPrimary: false)
    ]
    
    private var totalDue: Double {
        cards.map { $0.currentDue }.reduce(0, +)
    }
    
    private var upcomingCard: CreditCard? {
        cards.first
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    summarySection
                    upcomingDueSection
                    cardsListSection
                    recentPaymentsSection
                }
                .padding(20)
            }
            .background(Color.lightGreen.ignoresSafeArea())
            .navigationTitle("Pay Credit Debt")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Total Outstanding")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    Text("₹\(totalDue, specifier: "%.0f")")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    Text("Across \(cards.count) cards")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text("Smart Suggestion")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("Pay at least the minimum due today to avoid interest.")
                        .font(.caption)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Safe to spend")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("₹58,000")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                }
                
                Spacer()
                
                Button {
                } label: {
                    Text("Pay all dues")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.primaryGreen)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var upcomingDueSection: some View {
        Group {
            if let upcomingCard = upcomingCard {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Upcoming due")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Text("Due on \(upcomingCard.dueDate)")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(upcomingCard.bank) • •••• \(upcomingCard.last4)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.textPrimary)
                                
                                Text("Total limit ₹\(upcomingCard.totalLimit, specifier: "%.0f")")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Due now")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                                
                                Text("₹\(upcomingCard.currentDue, specifier: "%.0f")")
                                    .font(.headline)
                                    .foregroundColor(.errorRed)
                            }
                        }
                        
                        let utilisation = upcomingCard.currentDue / upcomingCard.totalLimit
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.gray.opacity(0.15))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 6)
                                .fill(utilisation > 0.8 ? Color.errorRed : Color.primaryGreen)
                                .frame(width: CGFloat(min(max(utilisation, 0), 1)) * UIScreen.main.bounds.width * 0.55, height: 8)
                        }
                        
                        HStack {
                            Text("Min due ₹\(upcomingCard.minDue, specifier: "%.0f")")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            
                            Spacer()
                            
                            Text("Utilisation \(Int(utilisation * 100))%")
                                .font(.caption)
                                .foregroundColor(utilisation > 0.8 ? .errorRed : .primaryGreen)
                        }
                        
                        Button {
                        } label: {
                            HStack {
                                Text("Pay minimum due")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.primaryGreen)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
            }
        }
    }
    
    private var cardsListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your cards")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            ForEach(cards) { card in
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(card.isPrimary ? Color.primaryGreen.opacity(0.15) : Color.gray.opacity(0.1))
                        .frame(width: 48, height: 48)
                        .overlay(
                            Image(systemName: "creditcard.fill")
                                .foregroundColor(card.isPrimary ? .primaryGreen : .textSecondary)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(card.bank) • •••• \(card.last4)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                        
                        Text("Due on \(card.dueDate)")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("₹\(card.currentDue, specifier: "%.0f")")
                            .font(.headline)
                            .foregroundColor(.errorRed)
                        
                        Button {
                        } label: {
                            Text("Pay")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryGreen)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.primaryGreen.opacity(0.08))
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(14)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: .gray.opacity(0.06), radius: 4, x: 0, y: 2)
            }
        }
    }
    
    private var recentPaymentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent payments")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("View all")
                    .font(.caption)
                    .foregroundColor(.primaryGreen)
            }
            
            VStack(spacing: 12) {
                paymentRow(bank: "HDFC Bank", last4: "4821", amount: "₹8,000", time: "3 days ago")
                paymentRow(bank: "SBI Card", last4: "9934", amount: "₹5,500", time: "Last week")
                paymentRow(bank: "Axis Neo", last4: "7712", amount: "₹2,000", time: "2 weeks ago")
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
        }
    }
    
    private func paymentRow(bank: String, last4: String, amount: String, time: String) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.primaryGreen.opacity(0.1))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "arrow.down.left")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primaryGreen)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(bank) • •••• \(last4)")
                    .font(.subheadline)
                    .foregroundColor(.textPrimary)
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Text(amount)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
        }
    }
}

#Preview {
    CreditDebtView()
}
