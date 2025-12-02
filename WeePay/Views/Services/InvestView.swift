//
//  InvestView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 24/07/25.
//

import SwiftUI

struct InvestView: View {
    enum Filter: String, CaseIterable {
        case all = "All"
        case equity = "Equity"
        case mutualFunds = "Mutual Funds"
        case gold = "Gold"
    }
    
    struct Holding: Identifiable {
        let id = UUID()
        let name: String
        let type: Filter
        let value: Double
        let invested: Double
        let todayPnl: Double
        let overallPnl: Double
        let allocation: Double
    }
    
    @State private var selectedFilter: Filter = .all
    
    private let holdings: [Holding] = [
        Holding(name: "Nifty 50 Index", type: .mutualFunds, value: 85000, invested: 72000, todayPnl: 620, overallPnl: 13000, allocation: 0.35),
        Holding(name: "HDFC Bank", type: .equity, value: 42000, invested: 36000, todayPnl: -230, overallPnl: 6000, allocation: 0.18),
        Holding(name: "TCS", type: .equity, value: 38000, invested: 30000, todayPnl: 310, overallPnl: 8000, allocation: 0.16),
        Holding(name: "Gold ETF", type: .gold, value: 26000, invested: 24000, todayPnl: 80, overallPnl: 2000, allocation: 0.12),
        Holding(name: "Midcap Fund", type: .mutualFunds, value: 35000, invested: 32000, todayPnl: -120, overallPnl: 3000, allocation: 0.19)
    ]
    
    private var filteredHoldings: [Holding] {
        holdings.filter { selectedFilter == .all || $0.type == selectedFilter }
    }
    
    private var totalInvested: Double {
        holdings.map { $0.invested }.reduce(0, +)
    }
    
    private var totalCurrent: Double {
        holdings.map { $0.value }.reduce(0, +)
    }
    
    private var totalOverallPnl: Double {
        holdings.map { $0.overallPnl }.reduce(0, +)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    portfolioSummarySection
                    performanceSection
                    filterChipsSection
                    holdingsSection
                    insightsSection
                }
                .padding(20)
            }
            .background(Color.lightGreen.ignoresSafeArea())
            .navigationTitle("Invest")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var portfolioSummarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Total portfolio value")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
            
            Text("₹\(totalCurrent, specifier: "%.0f")")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.textPrimary)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Invested")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("₹\(totalInvested, specifier: "%.0f")")
                        .font(.subheadline)
                        .foregroundColor(.textPrimary)
                }
                
                Divider()
                    .frame(height: 28)
                
                let pnlPositive = totalOverallPnl >= 0
                VStack(alignment: .leading, spacing: 4) {
                    Text("Overall P&L")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("\(pnlPositive ? "+" : "")₹\(abs(totalOverallPnl), specifier: "%.0f")")
                        .font(.subheadline)
                        .foregroundColor(pnlPositive ? .primaryGreen : .errorRed)
                }
            }
            
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.primaryGreen)
                    .font(.caption)
                
                Text("You are on track for your goals. Continue investing ₹5,000/month to reach ₹10L in 5 years.")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var performanceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Performance")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("1Y · CAGR 14.2%")
                    .font(.caption)
                    .foregroundColor(.primaryGreen)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.primaryGreen.opacity(0.1), Color.accentGreen.opacity(0.05)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 140)
                
                GeometryReader { geometry in
                    let width = geometry.size.width - 32
                    let baseLine = geometry.size.height * 0.55
                    Path { path in
                        path.move(to: CGPoint(x: 16, y: baseLine))
                        path.addCurve(
                            to: CGPoint(x: width * 0.4, y: baseLine - 24),
                            control1: CGPoint(x: width * 0.2, y: baseLine - 10),
                            control2: CGPoint(x: width * 0.3, y: baseLine - 28)
                        )
                        path.addCurve(
                            to: CGPoint(x: width * 0.75, y: baseLine - 10),
                            control1: CGPoint(x: width * 0.5, y: baseLine - 20),
                            control2: CGPoint(x: width * 0.6, y: baseLine)
                        )
                        path.addCurve(
                            to: CGPoint(x: width, y: baseLine - 36),
                            control1: CGPoint(x: width * 0.85, y: baseLine - 20),
                            control2: CGPoint(x: width * 0.9, y: baseLine - 40)
                        )
                    }
                    .stroke(Color.primaryGreen, style: StrokeStyle(lineWidth: 2.5, lineJoin: .round))
                    
                    Path { path in
                        path.move(to: CGPoint(x: 16, y: baseLine))
                        path.addCurve(
                            to: CGPoint(x: width * 0.4, y: baseLine - 24),
                            control1: CGPoint(x: width * 0.2, y: baseLine - 10),
                            control2: CGPoint(x: width * 0.3, y: baseLine - 28)
                        )
                        path.addCurve(
                            to: CGPoint(x: width * 0.75, y: baseLine - 10),
                            control1: CGPoint(x: width * 0.5, y: baseLine - 20),
                            control2: CGPoint(x: width * 0.6, y: baseLine)
                        )
                        path.addCurve(
                            to: CGPoint(x: width, y: baseLine - 36),
                            control1: CGPoint(x: width * 0.85, y: baseLine - 20),
                            control2: CGPoint(x: width * 0.9, y: baseLine - 40)
                        )
                        path.addLine(to: CGPoint(x: width, y: geometry.size.height - 10))
                        path.addLine(to: CGPoint(x: 16, y: geometry.size.height - 10))
                        path.closeSubpath()
                    }
                    .fill(Color.primaryGreen.opacity(0.12))
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .frame(height: 140)
            
            HStack {
                Text("Better than 78% of similar portfolios")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                Spacer()
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var filterChipsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Filter.allCases, id: \.self) { filter in
                    Button {
                        selectedFilter = filter
                    } label: {
                        HStack(spacing: 6) {
                            Text(filter.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(selectedFilter == filter ? Color.primaryGreen : Color.white)
                        .foregroundColor(selectedFilter == filter ? .white : .textPrimary)
                        .clipShape(Capsule())
                        .shadow(color: selectedFilter == filter ? Color.primaryGreen.opacity(0.25) : .clear, radius: 6, x: 0, y: 3)
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    private var holdingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Holdings")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("Value · Today · P&L")
                    .font(.caption2)
                    .foregroundColor(.textSecondary)
            }
            
            ForEach(filteredHoldings) { holding in
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.primaryGreen.opacity(0.12))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(String(holding.name.prefix(1)))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryGreen)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(holding.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                        
                        Text(holding.type.rawValue)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("₹\(holding.value, specifier: "%.0f")")
                            .font(.subheadline)
                            .foregroundColor(.textPrimary)
                        
                        let todayPositive = holding.todayPnl >= 0
                        Text("\(todayPositive ? "+" : "")₹\(abs(holding.todayPnl), specifier: "%.0f") today")
                            .font(.caption2)
                            .foregroundColor(todayPositive ? .primaryGreen : .errorRed)
                        
                        let pnlPositive = holding.overallPnl >= 0
                        Text("\(pnlPositive ? "+" : "")₹\(abs(holding.overallPnl), specifier: "%.0f") total")
                            .font(.caption2)
                            .foregroundColor(pnlPositive ? .primaryGreen : .errorRed)
                    }
                }
                .padding(14)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: .gray.opacity(0.06), radius: 4, x: 0, y: 2)
            }
        }
    }
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Smart insights")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                insightRow(icon: "sparkles", title: "Increase SIP in Nifty 50 by ₹1,500", subtitle: "Your long-term goal can be reached 8 months earlier.")
                insightRow(icon: "arrow.triangle.2.circlepath", title: "Rebalance equity and debt", subtitle: "Move ₹10,000 from midcap fund to low-risk fund.")
                insightRow(icon: "shield.checkerboard", title: "Add emergency fund", subtitle: "You are 1.5 months away from recommended 6 months buffer.")
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
        }
    }
    
    private func insightRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(Color.primaryGreen.opacity(0.12))
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primaryGreen)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.textPrimary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        InvestView()
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    .environmentObject(AuthStateManager(isPreview: true))
}
