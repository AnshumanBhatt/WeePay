//
//  ExpenseDashboardView.swift
//  WeePay
//
//  Created by Preview Stub
//

import SwiftUI

struct ExpenseDashboardView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var expenseViewModel = ExpenseTrackingViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Summary Cards
                    HStack(spacing: 16) {
                        SummaryCard(
                            title: "This Month",
                            amount: expenseViewModel.monthlyExpenses,
                            color: .red,
                            icon: "arrow.up.circle.fill"
                        )
                        
                        SummaryCard(
                            title: "Savings",
                            amount: expenseViewModel.monthlySavings,
                            color: expenseViewModel.monthlySavings >= 0 ? .primaryGreen : .red,
                            icon: "arrow.down.circle.fill"
                        )
                    }
                    
                    // Weekly Budget Progress
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Weekly Budget")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("₹\(Int(expenseViewModel.weeklySpent)) of ₹\(Int(expenseViewModel.weeklyBudget))")
                                    .font(.subheadline)
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                                
                                Text("\(Int((expenseViewModel.weeklySpent / expenseViewModel.weeklyBudget) * 100))%")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.textSecondary)
                            }
                            
                            ProgressView(value: expenseViewModel.getWeeklyBudgetProgress())
                                .progressViewStyle(LinearProgressViewStyle())
                                .accentColor(.primaryGreen)
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
                    
                    // Category Breakdown
                    if !expenseViewModel.categoryTotals.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Category Breakdown")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                            
                            VStack(spacing: 12) {
                                ForEach(Array(expenseViewModel.categoryTotals.sorted(by: { $0.value > $1.value }).prefix(5)), id: \.key) { category, amount in
                                    CategoryBreakdownRow(
                                        category: category,
                                        amount: amount,
                                        percentage: (amount / expenseViewModel.monthlyExpenses) * 100
                                    )
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
                    }
                    
                    // Insights
                    if !expenseViewModel.generateMonthlyInsights().isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Insights")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                            
                            VStack(spacing: 12) {
                                ForEach(expenseViewModel.generateMonthlyInsights(), id: \.self) { insight in
                                    InsightRow(text: insight)
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .background(Color.lightGreen.ignoresSafeArea())
            .navigationTitle("Expense Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SummaryCard: View {
    let title: String
    let amount: Double
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
            
            Text("₹\(String(format: \"%.2f\", amount))")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

struct CategoryBreakdownRow: View {
    let category: String
    let amount: Double
    let percentage: Double
    
    private var categoryInfo: ExpenseCategoryModel {
        ExpenseCategoryModel.getCategoryByName(category)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(categoryInfo.color.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: categoryInfo.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(categoryInfo.color)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text("\(Int(percentage))% of total")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Text("₹\(String(format: \"%.2f\", amount))")
                .font(.headline)
                .foregroundColor(.textPrimary)
        }
    }
}

struct InsightRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.title3)
                .foregroundColor(.primaryGreen)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(16)
        .background(Color.mintGreen)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ExpenseDashboardView()
}
