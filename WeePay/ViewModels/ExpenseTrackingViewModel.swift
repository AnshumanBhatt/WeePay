//
//  ExpenseTrackingViewModel.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 26/08/25.
//

import Foundation
import CoreData
import SwiftUI
import Combine

@MainActor
class ExpenseTrackingViewModel: ObservableObject {
    @Published var transactions: [ExpenseTransaction] = []
    @Published var monthlyExpenses: Double = 0.0
    @Published var monthlyIncome: Double = 0.0
    @Published var monthlySavings: Double = 0.0
    @Published var weeklySpent: Double = 0.0
    @Published var weeklyBudget: Double = 5000.0
    @Published var categoryTotals: [String: Double] = [:]
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showError = false
    
    private let persistenceController: PersistenceController?
    private var cancellables = Set<AnyCancellable>()
    private let isPreview: Bool 
    
    init(persistenceController: PersistenceController? = nil, isPreview: Bool = false) {
        self.isPreview = isPreview
        self.persistenceController = persistenceController ?? (isPreview ? nil : PersistenceController.shared)
        
        if isPreview {
            setupPreviewData()
        } else {
            loadTransactions()
            calculateMonthlyData()
        }
    }
    
    private func setupPreviewData() {
        // Setup sample data for preview
        monthlyExpenses = 15420.50
        monthlyIncome = 45000.00
        monthlySavings = monthlyIncome - monthlyExpenses
        weeklySpent = 3250.00
        categoryTotals = [
            "Food": 5200.00,
            "Travel": 3400.00,
            "Shopping": 2800.00,
            "Bills": 2500.00,
            "Entertainment": 1520.50
        ]
    }
    
    // MARK: - Core Data Operations
    
    func addTransaction(
        title: String,
        amount: Double,
        type: TransactionType,
        category: String,
        description: String = "",
        paymentMethod: PaymentMethod? = nil,
        recipientName: String? = nil,
        recipientPhone: String? = nil
    ) {
        guard let persistenceController = persistenceController else {
            // In preview mode, just update local data
            monthlyExpenses += (type == .expense) ? amount : 0
            monthlyIncome += (type == .income) ? amount : 0
            monthlySavings = monthlyIncome - monthlyExpenses
            return
        }
        
        let context = persistenceController.container.viewContext
        
        let transaction = ExpenseTransaction(context: context)
        transaction.id = UUID()
        transaction.title = title
        transaction.amount = amount
        transaction.type = type.rawValue
        transaction.category = category
        transaction.descriptionText = description.isEmpty ? nil : description
        transaction.paymentMethod = paymentMethod?.rawValue
        transaction.recipientName = recipientName
        transaction.recipientPhoneNumber = recipientPhone
        transaction.date = Date()
        transaction.isManualEntry = true
        transaction.createdAt = Date()
        transaction.updatedAt = Date()
        
        do {
            try context.save()
            loadTransactions()
            calculateMonthlyData()
        } catch {
            errorMessage = "Failed to save transaction: \(error.localizedDescription)"
            showError = true
        }
    }
    
    func loadTransactions() {
        guard let persistenceController = persistenceController else {
            // In preview mode, return empty transactions
            transactions = []
            return
        }
        
        let context = persistenceController.container.viewContext
        let request: NSFetchRequest<ExpenseTransaction> = ExpenseTransaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ExpenseTransaction.date, ascending: false)]
        
        do {
            transactions = try context.fetch(request)
        } catch {
            errorMessage = "Failed to load transactions: \(error.localizedDescription)"
            showError = true
        }
    }
    
    func deleteTransaction(_ transaction: ExpenseTransaction) {
        guard let persistenceController = persistenceController else {
            // In preview mode, just return
            return
        }
        
        let context = persistenceController.container.viewContext
        context.delete(transaction)
        
        do {
            try context.save()
            loadTransactions()
            calculateMonthlyData()
        } catch {
            errorMessage = "Failed to delete transaction: \(error.localizedDescription)"
            showError = true
        }
    }
    
    // MARK: - Data Calculations
    
    func calculateMonthlyData() {
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)
        
        let currentMonthTransactions = transactions.filter { transaction in
            let transactionMonth = calendar.component(.month, from: transaction.date ?? Date())
            let transactionYear = calendar.component(.year, from: transaction.date ?? Date())
            return transactionMonth == currentMonth && transactionYear == currentYear
        }
        
        monthlyExpenses = currentMonthTransactions
            .filter { $0.type == TransactionType.expense.rawValue }
            .reduce(0) { $0 + $1.amount }
        
        monthlyIncome = currentMonthTransactions
            .filter { $0.type == TransactionType.income.rawValue }
            .reduce(0) { $0 + $1.amount }
        
        monthlySavings = monthlyIncome - monthlyExpenses
        
        // Calculate category totals
        var categorySum: [String: Double] = [:]
        for transaction in currentMonthTransactions.filter({ $0.type == TransactionType.expense.rawValue }) {
            let category = transaction.category ?? "Other"
            categorySum[category, default: 0] += transaction.amount
        }
        categoryTotals = categorySum
        
        // Calculate weekly spending
        calculateWeeklySpending()
    }
    
    private func calculateWeeklySpending() {
        let calendar = Calendar.current
        let now = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        
        let weeklyTransactions = transactions.filter { transaction in
            guard let transactionDate = transaction.date else { return false }
            return transactionDate >= weekAgo && transaction.type == TransactionType.expense.rawValue
        }
        
        weeklySpent = weeklyTransactions.reduce(0) { $0 + $1.amount }
    }
    
    func getTransactionsForCategory(_ category: String) -> [ExpenseTransaction] {
        return transactions.filter { $0.category == category }
    }
    
    func getTransactionsForDateRange(from startDate: Date, to endDate: Date) -> [ExpenseTransaction] {
        return transactions.filter { transaction in
            guard let date = transaction.date else { return false }
            return date >= startDate && date <= endDate
        }
    }
    
    // MARK: - Insights & Analytics
    
    func getMonthlyComparison() -> (currentMonth: Double, lastMonth: Double, percentageChange: Double) {
        let calendar = Calendar.current
        let now = Date()
        
        // Current month
        let currentMonthStart = calendar.dateInterval(of: .month, for: now)?.start ?? now
        let currentMonthEnd = calendar.dateInterval(of: .month, for: now)?.end ?? now
        
        // Last month
        let lastMonth = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        let lastMonthStart = calendar.dateInterval(of: .month, for: lastMonth)?.start ?? lastMonth
        let lastMonthEnd = calendar.dateInterval(of: .month, for: lastMonth)?.end ?? lastMonth
        
        let currentMonthExpenses = getTransactionsForDateRange(from: currentMonthStart, to: currentMonthEnd)
            .filter { $0.type == TransactionType.expense.rawValue }
            .reduce(0) { $0 + $1.amount }
        
        let lastMonthExpenses = getTransactionsForDateRange(from: lastMonthStart, to: lastMonthEnd)
            .filter { $0.type == TransactionType.expense.rawValue }
            .reduce(0) { $0 + $1.amount }
        
        let percentageChange = lastMonthExpenses > 0 
            ? ((currentMonthExpenses - lastMonthExpenses) / lastMonthExpenses) * 100 
            : 0
        
        return (currentMonthExpenses, lastMonthExpenses, percentageChange)
    }
    
    func generateMonthlyInsights() -> [String] {
        var insights: [String] = []
        
        let comparison = getMonthlyComparison()
        let percentageChange = comparison.percentageChange
        
        if percentageChange < -10 {
            insights.append("Great job! You spent \(abs(Int(percentageChange)))% less this month compared to last month.")
        } else if percentageChange > 10 {
            insights.append("You spent \(Int(percentageChange))% more this month. Consider reviewing your expenses.")
        } else {
            insights.append("Your spending is consistent with last month.")
        }
        
        // Top category insight
        if let topCategory = categoryTotals.max(by: { $0.value < $1.value }) {
            let percentage = (topCategory.value / monthlyExpenses) * 100
            insights.append("\(topCategory.key) is your top expense category at \(Int(percentage))% of total spending.")
        }
        
        // Savings insight
        if monthlySavings > 0 {
            insights.append("You saved ₹\(Int(monthlySavings)) this month!")
        } else if monthlySavings < 0 {
            insights.append("You spent ₹\(abs(Int(monthlySavings))) more than your income this month.")
        }
        
        // Weekly budget insight
        let weeklyBudgetPercentage = (weeklySpent / weeklyBudget) * 100
        if weeklyBudgetPercentage > 80 {
            insights.append("You've spent ₹\(Int(weeklySpent)) this week, \(Int(weeklyBudgetPercentage))% of your weekly budget.")
        }
        
        return insights
    }
    
    // MARK: - Utility Functions
    
    func formatCurrency(_ amount: Double) -> String {
        return "₹\(String(format: "%.2f", amount))"
    }
    
    func getWeeklyBudgetProgress() -> Double {
        return min(weeklySpent / weeklyBudget, 1.0)
    }
}
