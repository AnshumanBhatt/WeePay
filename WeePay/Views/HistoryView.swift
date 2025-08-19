//
//  HistoryView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 15/07/25.
//

import SwiftUI

struct HistoryView: View {
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    @State private var showingFilterSheet = false
    
    let filterOptions = ["All", "Sent", "Received", "Recharged", "Bills"]
    
    let transactions = [
        Transaction(id: 1, title: "Rahul Sharma", subtitle: "Money sent", amount: -500.00, time: "2 hours ago", type: .sent),
        Transaction(id: 2, title: "Salary Credit", subtitle: "Bank transfer", amount: 25000.00, time: "Yesterday", type: .received),
        Transaction(id: 3, title: "Priya Patel", subtitle: "Money received", amount: 1200.00, time: "2 days ago", type: .received),
        Transaction(id: 4, title: "Mobile Recharge", subtitle: "Airtel prepaid", amount: -399.00, time: "3 days ago", type: .recharge),
        Transaction(id: 5, title: "Electricity Bill", subtitle: "MSEB payment", amount: -1850.00, time: "1 week ago", type: .bill),
        Transaction(id: 6, title: "Amit Kumar", subtitle: "Money sent", amount: -750.00, time: "1 week ago", type: .sent),
        Transaction(id: 7, title: "Cashback", subtitle: "Reward credit", amount: 50.00, time: "2 weeks ago", type: .received),
        Transaction(id: 8, title: "DTH Recharge", subtitle: "Tata Sky", amount: -299.00, time: "2 weeks ago", type: .recharge)
    ]
    
    var filteredTransactions: [Transaction] {
        var filtered = transactions
        
        if selectedFilter != "All" {
            filtered = filtered.filter { transaction in
                switch selectedFilter {
                case "Sent":
                    return transaction.type == .sent
                case "Received":
                    return transaction.type == .received
                case "Recharged":
                    return transaction.type == .recharge
                case "Bills":
                    return transaction.type == .bill
                default:
                    return true
                }
            }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { transaction in
                transaction.title.localizedCaseInsensitiveContains(searchText) ||
                transaction.subtitle.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Search and Filter
                searchAndFilterSection
                
                // Transaction List
                transactionList
            }
            .background(Color.lightGreen.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text("Transaction History")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "arrow.down.doc.fill")
                    .font(.title2)
                    .foregroundColor(.primaryGreen)
                    .padding(12)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchAndFilterSection: some View {
        VStack(spacing: 16) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textSecondary)
                
                TextField("Search transactions...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
            
            // Filter Options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(filterOptions, id: \.self) { option in
                        FilterChip(
                            title: option,
                            isSelected: selectedFilter == option,
                            action: { selectedFilter = option }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var transactionList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredTransactions) { transaction in
                    DetailedTransactionRow(transaction: transaction)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.primaryGreen : Color.white)
                .foregroundColor(isSelected ? .white : .textPrimary)
                .clipShape(Capsule())
                .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

struct DetailedTransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Icon
                Circle()
                    .fill(transaction.amount < 0 ? Color.errorRed.opacity(0.1) : Color.primaryGreen.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: transaction.iconName)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(transaction.amount < 0 ? .errorRed : .primaryGreen)
                    )
                
                // Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.title)
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text(transaction.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    Text(transaction.time)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                // Amount
                Text(transaction.formattedAmount)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(transaction.amount < 0 ? .errorRed : .primaryGreen)
            }
            
            // Status Badge
            HStack {
                Spacer()
                
                Text(transaction.statusText)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(transaction.statusColor.opacity(0.1))
                    .foregroundColor(transaction.statusColor)
                    .clipShape(Capsule())
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

struct Transaction: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let amount: Double
    let time: String
    let type: TransactionType
    
    var formattedAmount: String {
        let prefix = amount < 0 ? "-" : "+"
        return "\(prefix)₹\(abs(amount))"
    }
    
    var iconName: String {
        switch type {
        case .sent:
            return "arrow.up.right"
        case .received:
            return "arrow.down.left"
        case .recharge:
            return "phone.fill"
        case .bill:
            return "bolt.fill"
        }
    }
    
    var statusText: String {
        switch type {
        case .sent:
            return "Completed"
        case .received:
            return "Received"
        case .recharge:
            return "Successful"
        case .bill:
            return "Paid"
        }
    }
    
    var statusColor: Color {
        switch type {
        case .sent:
            return .primaryGreen
        case .received:
            return .primaryGreen
        case .recharge:
            return .accentGreen
        case .bill:
            return .warningOrange
        }
    }
}

enum TransactionType {
    case sent
    case received
    case recharge
    case bill
}

#Preview {
    NavigationStack {
        HistoryView()
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    .environmentObject(AuthStateManager())
}
