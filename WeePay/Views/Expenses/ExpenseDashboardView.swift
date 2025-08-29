//
//  ExpenseDashboardView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 26/08/25.
//

import SwiftUI
import Charts

struct ExpenseDashboardView: View {
    @StateObject private var expenseViewModel = ExpenseTrackingViewModel()
    @State private var selectedTimeRange: TimeRange = .thisMonth
    @State private var showingAddExpense = false
    
    enum TimeRange: String, CaseIterable {
        case thisWeek = "This Week"
        case thisMonth = "This Month"
        case lastMonth = "Last Month"
        case thisYear = "This Year"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lightGreen.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerSection
                        
                        // Time Range Selector
                        timeRangeSelector
                        
                        // Summary Cards
                        summaryCards
                        
                        // Category Pie Chart
                        categoryPieChart
                        
                        // Monthly Comparison Chart
                        monthlyComparisonChart
                        
                        // Savings Trend
                        savingsTrendCard
                        
                        // Weekly Budget Progress
                        weeklyBudgetCard
                        
                        // Insights Section
                        insightsSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarHidden(true)
            .refreshable {
                expenseViewModel.loadTransactions()
                expenseViewModel.calculateMonthlyData()
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView()
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Expense Overview")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text("Track your spending patterns")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Button(action: { showingAddExpense = true }) {
                Image(systemName: "plus.circle.fill")
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
    
    private var timeRangeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TimeRange.allCases, id: \.rawValue) { range in
                    Button(action: { selectedTimeRange = range }) {
                        Text(range.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedTimeRange == range ? Color.primaryGreen : Color.white)
                            .foregroundColor(selectedTimeRange == range ? .white : .textPrimary)
                            .clipShape(Capsule())
                            .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var summaryCards: some View {
        HStack(spacing: 12) {
            SummaryCard(
                title: "Monthly Expenses",
                value: expenseViewModel.formatCurrency(expenseViewModel.monthlyExpenses),
                icon: "arrow.up.circle.fill",
                color: .red
            )
            
            SummaryCard(
                title: "Monthly Income",
                value: expenseViewModel.formatCurrency(expenseViewModel.monthlyIncome),
                icon: "arrow.down.circle.fill",
                color: .primaryGreen
            )
            
            SummaryCard(
                title: "Savings",
                value: expenseViewModel.formatCurrency(expenseViewModel.monthlySavings),
                icon: "banknote.fill",
                color: expenseViewModel.monthlySavings >= 0 ? .primaryGreen : .red
            )
        }
    }
    
    private var categoryPieChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Expense Categories")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if !expenseViewModel.categoryTotals.isEmpty {
                Chart {
                    ForEach(expenseViewModel.categoryTotals.sorted(by: { $0.value > $1.value }), id: \.key) { category, amount in
                        SectorMark(
                            angle: .value("Amount", amount),
                            innerRadius: .ratio(0.5),
                            outerRadius: .ratio(1.0)
                        )
                        .foregroundStyle(ExpenseCategoryModel.getCategoryColor(category))
                        .opacity(0.8)
                    }
                }
                .frame(height: 200)
                .chartLegend(position: .bottom, alignment: .leading)
                
                // Category Legend
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                    ForEach(expenseViewModel.categoryTotals.sorted(by: { $0.value > $1.value }), id: \.key) { category, amount in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(ExpenseCategoryModel.getCategoryColor(category))
                                .frame(width: 12, height: 12)
                            
                            Text(category)
                                .font(.caption)
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                            
                            Text(expenseViewModel.formatCurrency(amount))
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                .padding(.top, 8)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.textSecondary.opacity(0.5))
                    
                    Text("No expense data available")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    Text("Add some expenses to see your spending breakdown")
                        .font(.caption)
                        .foregroundColor(.textSecondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(height: 200)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
    }
    
    private var monthlyComparisonChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Comparison")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            let comparison = expenseViewModel.getMonthlyComparison()
            let data = [
                MonthlyData(month: "Last Month", amount: comparison.lastMonth),
                MonthlyData(month: "This Month", amount: comparison.currentMonth)
            ]
            
            Chart {
                ForEach(data) { item in
                    BarMark(
                        x: .value("Month", item.month),
                        y: .value("Amount", item.amount)
                    )
                    .foregroundStyle(item.month == "This Month" ? Color.primaryGreen : Color.accentGreen)
                    .cornerRadius(8)
                }
            }
            .frame(height: 150)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let amount = value.as(Double.self) {
                            Text("₹\(Int(amount))")
                                .font(.caption)
                        }
                    }
                }
            }
            
            // Comparison Text
            HStack {
                Image(systemName: comparison.percentageChange >= 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                    .foregroundColor(comparison.percentageChange >= 0 ? .red : .primaryGreen)
                
                Text("\(abs(comparison.percentageChange), specifier: "%.1f")% \(comparison.percentageChange >= 0 ? "increase" : "decrease") from last month")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .padding(.top, 8)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
    }
    
    private var savingsTrendCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Savings This Month")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Image(systemName: expenseViewModel.monthlySavings >= 0 ? "arrow.up.right.circle.fill" : "arrow.down.right.circle.fill")
                    .foregroundColor(expenseViewModel.monthlySavings >= 0 ? .primaryGreen : .red)
            }
            
            Text(expenseViewModel.formatCurrency(abs(expenseViewModel.monthlySavings)))
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(expenseViewModel.monthlySavings >= 0 ? .primaryGreen : .red)
            
            Text(expenseViewModel.monthlySavings >= 0 ? "Great job saving money!" : "You're spending more than earning")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: expenseViewModel.monthlySavings >= 0 ? 
                    [Color.primaryGreen.opacity(0.1), Color.accentGreen.opacity(0.1)] :
                    [Color.red.opacity(0.1), Color.orange.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(expenseViewModel.monthlySavings >= 0 ? Color.primaryGreen.opacity(0.3) : Color.red.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var weeklyBudgetCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Weekly Budget")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(Int((expenseViewModel.getWeeklyBudgetProgress() * 100)))%")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Spent: \(expenseViewModel.formatCurrency(expenseViewModel.weeklySpent))")
                        .font(.subheadline)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Text("Budget: \(expenseViewModel.formatCurrency(expenseViewModel.weeklyBudget))")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }
                
                ProgressView(value: expenseViewModel.getWeeklyBudgetProgress())
                    .progressViewStyle(LinearProgressViewStyle(tint: expenseViewModel.getWeeklyBudgetProgress() > 0.8 ? .red : .primaryGreen))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
    }
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Smart Insights")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                ForEach(expenseViewModel.generateMonthlyInsights(), id: \.self) { insight in
                    InsightCard(text: insight)
                }
            }
        }
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct InsightCard: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.primaryGreen)
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct MonthlyData: Identifiable {
    let id = UUID()
    let month: String
    let amount: Double
}

#Preview {
    ExpenseDashboardView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
