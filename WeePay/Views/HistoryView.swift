//
//  HistoryView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 15/07/25.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    @StateObject private var expenseViewModel = ExpenseTrackingViewModel()
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    @State private var showingFilterSheet = false
    @State private var showingAddExpense = false
    
    let filterOptions = ["All", "Expense", "Income", "Payment"]
    
    var filteredTransactions: [ExpenseTransaction] {
        var filtered = expenseViewModel.transactions
        
        if selectedFilter != "All" {
            filtered = filtered.filter { transaction in
                switch selectedFilter {
                case "Expense":
                    return transaction.type == TransactionType.expense.rawValue
                case "Income":
                    return transaction.type == TransactionType.income.rawValue
                case "Payment":
                    return transaction.type == TransactionType.payment.rawValue
                default:
                    return true
                }
            }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { transaction in
                (transaction.title?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (transaction.category?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (transaction.descriptionText?.localizedCaseInsensitiveContains(searchText) ?? false)
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
            if filteredTransactions.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.textSecondary.opacity(0.5))
                    
                    Text("No transactions found")
                        .font(.headline)
                        .foregroundColor(.textSecondary)
                    
                    Text("Add some transactions to see them here")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                    
                    Button("Add Transaction") {
                        showingAddExpense = true
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.primaryGreen)
                    .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(filteredTransactions, id: \.id) { transaction in
                        ExpenseTransactionRow(transaction: transaction) {
                            expenseViewModel.deleteTransaction(transaction)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView()
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

struct ExpenseTransactionRow: View {
    let transaction: ExpenseTransaction
    let onDelete: () -> Void
    
    private var transactionType: TransactionType {
        TransactionType(rawValue: transaction.type ?? "") ?? .expense
    }
    
    private var categoryColor: Color {
        ExpenseCategoryModel.getCategoryColor(transaction.category ?? "Other")
    }
    
    private var categoryIcon: String {
        ExpenseCategoryModel.getCategoryIcon(transaction.category ?? "Other")
    }
    
    private var isExpense: Bool {
        transactionType == .expense || transactionType == .payment
    }
    
    private var formattedAmount: String {
        let prefix = isExpense ? "-" : "+"
        return "\(prefix)₹\(String(format: "%.2f", transaction.amount))"
    }
    
    private var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.localizedString(for: transaction.date ?? Date(), relativeTo: Date())
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Category Icon
                Circle()
                    .fill(categoryColor.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: categoryIcon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(categoryColor)
                    )
                
                // Transaction Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.title ?? "Unknown")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    HStack {
                        Text(transaction.category ?? "Other")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                        
                        if let paymentMethod = transaction.paymentMethod {
                            Text("•")
                                .foregroundColor(.textSecondary.opacity(0.5))
                            
                            Text(PaymentMethod(rawValue: paymentMethod)?.displayName ?? paymentMethod)
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    Text(formattedDate)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                // Amount
                VStack(alignment: .trailing, spacing: 4) {
                    Text(formattedAmount)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(isExpense ? .red : .primaryGreen)
                    
                    Text(transactionType.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(categoryColor.opacity(0.1))
                        .foregroundColor(categoryColor)
                        .clipShape(Capsule())
                }
            }
            
            // Description and Actions
            if let description = transaction.descriptionText, !description.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
        .contextMenu {
            Button("Delete", role: .destructive) {
                onDelete()
            }
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    .environmentObject(AuthStateManager())
}
