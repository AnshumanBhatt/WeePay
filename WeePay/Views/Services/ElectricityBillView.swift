//
//  ElectricityBillView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 24/07/25.
//

import SwiftUI

struct ElectricityBillView: View {
    struct Connection: Identifiable {
        let id = UUID()
        let name: String
        let provider: String
        let consumerNumber: String
        let currentBill: Double
        let dueDate: String
        let units: Int
        let isPrimary: Bool
    }
    
    private let connections: [Connection] = [
        Connection(name: "Home", provider: "BESCOM", consumerNumber: "1234 5678 9012", currentBill: 1860, dueDate: "22 Nov", units: 235, isPrimary: true),
        Connection(name: "Parents", provider: "UPPCL", consumerNumber: "9988 7766 5544", currentBill: 1320, dueDate: "28 Nov", units: 180, isPrimary: false)
    ]
    
    private var primaryConnection: Connection? { connections.first }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    currentBillSection
                    usageSummarySection
                    savedConnectionsSection
                    recentBillsSection
                }
                .padding(20)
            }
            .background(Color.lightGreen.ignoresSafeArea())
            .navigationTitle("Electricity Bill")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var currentBillSection: some View {
        Group {
            if let connection = primaryConnection {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Current bill")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                            
                            Text("₹\(connection.currentBill, specifier: "%.0f")")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.textPrimary)
                            
                            Text("Due by \(connection.dueDate)")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 6) {
                            Text(connection.name)
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                            
                            Text(connection.provider)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            
                            Text(connection.consumerNumber)
                                .font(.caption2)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Estimated units")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            
                            Text("\(connection.units) kWh")
                                .font(.headline)
                                .foregroundColor(.primaryGreen)
                        }
                        
                        Spacer()
                        
                        Button {
                        } label: {
                            Text("Pay now")
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
        }
    }
    
    private var usageSummarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Usage summary")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("This month")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("235 kWh")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    Text("₹7.9 / unit")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Last month")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("260 kWh")
                        .font(.subheadline)
                        .foregroundColor(.textPrimary)
                    
                    Text("-9% usage")
                        .font(.caption)
                        .foregroundColor(.primaryGreen)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                usageBarRow(label: "0 - 100 units", value: 0.7, color: .primaryGreen, subtitle: "Subsidised slab")
                usageBarRow(label: "101 - 200 units", value: 0.5, color: .accentGreen, subtitle: "Standard slab")
                usageBarRow(label: "200+ units", value: 0.3, color: .warningOrange, subtitle: "High tariff")
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private func usageBarRow(label: String, value: CGFloat, color: Color, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.textSecondary)
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(color)
                    .frame(width: max(0, min(1, value)) * UIScreen.main.bounds.width * 0.55, height: 8)
            }
        }
    }
    
    private var savedConnectionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Saved connections")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("Add new")
                    .font(.caption)
                    .foregroundColor(.primaryGreen)
            }
            
            ForEach(connections) { connection in
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(connection.isPrimary ? Color.primaryGreen.opacity(0.15) : Color.gray.opacity(0.1))
                        .frame(width: 46, height: 46)
                        .overlay(
                            Image(systemName: "bolt.fill")
                                .foregroundColor(connection.isPrimary ? .primaryGreen : .textSecondary)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(connection.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                        
                        Text(connection.provider)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text(connection.consumerNumber)
                            .font(.caption2)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("₹\(connection.currentBill, specifier: "%.0f")")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
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
    
    private var recentBillsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Bill history")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("View all")
                    .font(.caption)
                    .foregroundColor(.primaryGreen)
            }
            
            VStack(spacing: 12) {
                billRow(month: "Oct 2025", amount: "₹1,920", status: "Paid on 18 Oct")
                billRow(month: "Sep 2025", amount: "₹1,840", status: "Paid on 17 Sep")
                billRow(month: "Aug 2025", amount: "₹2,050", status: "Paid on 20 Aug")
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
        }
    }
    
    private func billRow(month: String, amount: String, status: String) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primaryGreen.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(month.prefix(3)))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryGreen)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(month)
                    .font(.subheadline)
                    .foregroundColor(.textPrimary)
                
                Text(status)
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
    ElectricityBillView()
}
