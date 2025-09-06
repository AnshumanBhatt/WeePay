//
//  HomeView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 15/07/25.
//

import SwiftUI


struct HomeView: View {
    @StateObject private var expenseViewModel: ExpenseTrackingViewModel
    @State private var bankCards: [BankCard] = BankCard.sampleCards
    @State private var showingSendMoney = false
    @State private var showingCheckBalance = false
    @State private var showingAddMoney = false
    @State private var showingSendToSelf = false
    @State private var showingSideMenu = false
    @State private var showingQRScanner = false
    @State private var showingAddExpense = false
    @State private var showingExpenseDashboard = false
    @State private var navigationPath = NavigationPath()
    
    init() {
        self._expenseViewModel = StateObject(wrappedValue: ExpenseTrackingViewModel())
    }
    
    init(isPreview: Bool) {
        self._expenseViewModel = StateObject(wrappedValue: ExpenseTrackingViewModel(isPreview: isPreview))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Section
                        headerSection
                        
                        // Card Carousel
                        CardCarouselView(cards: bankCards)
                        
                        // Horizontal Actions Card
                        HorizontalActionsCardAlt(
                            onSendMoneyTap: { showingSendMoney = true },
                            onCheckBalanceTap: { showingCheckBalance = true },
                            onSendToSelfTap: { showingSendToSelf = true }
                        )
                        
                        // Expense Summary Card
                        expenseSummaryCard
                        
                        // Monthly Comparison Card
                        monthlyComparisonCard
                        
                        // Services Section
                        servicesSection
                        
                        // Quick Actions
                        quickActionsSection
                        
                        // Recent Transactions Preview
                        recentTransactionsSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
                .background(Color.lightGreen.ignoresSafeArea())
            
                // Side Menu
                if showingSideMenu {
                    SideMenuView(
                        isShowing: $showingSideMenu,
                        onFAQTap: { 
                            navigationPath.append("FAQ")
                            showingSideMenu = false
                        },
                        onSettingsTap: { 
                            navigationPath.append("Settings")
                            showingSideMenu = false
                        },
                        onFeedbackTap: { 
                            navigationPath.append("Feedback")
                            showingSideMenu = false
                        }
                    )
                    .transition(.move(edge: .leading))
                    .zIndex(1)
                }
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "FAQ":
                    FAQView()
                case "Settings":
                    SettingsView()
                case "Feedback":
                    FeedbackView()
                default:
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
        .animation(.easeInOut(duration: 0.3), value: showingSideMenu)
        .sheet(isPresented: $showingQRScanner) {
            QRCodeScannerView()
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView()
        }
        .fullScreenCover(isPresented: $showingExpenseDashboard) {
            ExpenseDashboardView()
        }
    }
    
    private var headerSection: some View {
        HStack {
            Button(action: {
                showingSideMenu.toggle()
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundColor(.primaryGreen)
                    .padding(12)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Good Morning")
                    .font(.title2)
                    .foregroundColor(.textSecondary)
                
                Text("Anshuman")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell.fill")
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
    
    
    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Services")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                NavigationLink(destination: InvestView()) {
                    ServiceItem(icon: "chart.pie.fill", title: "Invest", color: .primaryGreen)
                }
                NavigationLink(destination: MetroTicketView()) {
                    ServiceItem(icon: "tram.fill", title: "Book Metro Ticket", color: .accentGreen)
                }
                NavigationLink(destination: ElectricityBillView()) {
                    ServiceItem(icon: "bolt.fill", title: "Pay Electricity Bill", color: .warningOrange)
                }
                NavigationLink(destination: CreditDebtView()) {
                    ServiceItem(icon: "creditcard.fill", title: "Pay Credit Debt", color: .primaryGreen)
                }
            }
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("More Actions")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    QuickActionItem(icon: "qrcode", title: "Scan QR", color: .primaryGreen) {
                        showingQRScanner = true
                    }
                    QuickActionItem(icon: "phone.fill", title: "Mobile Recharge", color: .accentGreen) {}
                }
                
                HStack(spacing: 12) {
                    QuickActionItem(icon: "car.fill", title: "Fuel", color: .primaryGreen) {}
                    QuickActionItem(icon: "tv.fill", title: "DTH", color: .accentGreen) {}
                }
                
                HStack(spacing: 12) {
                    QuickActionItem(icon: "bolt.fill", title: "Electricity", color: .warningOrange) {}
                    QuickActionItem(icon: "ellipsis", title: "More", color: .textSecondary) {}
                }
            }
        }
    }
    
    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Transactions")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button("View All") {
                    // Navigate to history
                }
                .foregroundColor(.primaryGreen)
                .font(.subheadline)
            }
            
            VStack(spacing: 12) {
                TransactionRow(
                    title: "Rahul Sharma",
                    subtitle: "Money sent",
                    amount: "-₹500.00",
                    time: "2 hours ago",
                    isDebit: true
                )
                
                TransactionRow(
                    title: "Salary Credit",
                    subtitle: "Bank transfer",
                    amount: "+₹25,000.00",
                    time: "Yesterday",
                    isDebit: false
                )
                
                TransactionRow(
                    title: "Priya Patel",
                    subtitle: "Money received",
                    amount: "+₹1,200.00",
                    time: "2 days ago",
                    isDebit: false
                )
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
        }
    }
    
    private var expenseSummaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Expense Tracking")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button("View Details") {
                    showingExpenseDashboard = true
                }
                .font(.subheadline)
                .foregroundColor(.primaryGreen)
            }
            
            HStack(spacing: 12) {
                // Monthly Expenses
                VStack(alignment: .leading, spacing: 4) {
                    Text("This Month")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text(expenseViewModel.formatCurrency(expenseViewModel.monthlyExpenses))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Monthly Savings
                VStack(alignment: .leading, spacing: 4) {
                    Text("Savings")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text(expenseViewModel.formatCurrency(expenseViewModel.monthlySavings))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(expenseViewModel.monthlySavings >= 0 ? .primaryGreen : .red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Quick Action Buttons
            HStack(spacing: 12) {
                Button("Add Expense") {
                    showingAddExpense = true
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.red)
                .clipShape(Capsule())
                
                Button("Add Income") {
                    showingAddExpense = true
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.primaryGreen)
                .clipShape(Capsule())
                
                Spacer()
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
    }
    
    private var monthlyComparisonCard: some View {
        let comparison = expenseViewModel.getMonthlyComparison()
        let percentageChange = comparison.percentageChange
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Comparison")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 20) {
                // Last Month
                VStack(alignment: .leading, spacing: 4) {
                    Text("Last Month")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text(expenseViewModel.formatCurrency(comparison.lastMonth))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                }
                
                // Comparison Arrow
                Image(systemName: percentageChange >= 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                    .font(.title)
                    .foregroundColor(percentageChange >= 0 ? .red : .primaryGreen)
                
                // This Month
                VStack(alignment: .leading, spacing: 4) {
                    Text("This Month")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text(expenseViewModel.formatCurrency(comparison.currentMonth))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                }
                
                Spacer()
                
                // Percentage Change
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(abs(percentageChange), specifier: "%.1f")%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(percentageChange >= 0 ? .red : .primaryGreen)
                    
                    Text(percentageChange >= 0 ? "increase" : "decrease")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            // Insights
            if let insight = expenseViewModel.generateMonthlyInsights().first {
                VStack(spacing: 8) {
                    Divider()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.primaryGreen)
                            .font(.caption)
                        
                        Text(insight)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

struct ActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let backgroundColor: Color
    var textColor: Color = .white
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(textColor)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(textColor)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(textColor.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(textColor.opacity(0.7))
            }
            .padding(20)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct QuickActionItem: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct ServiceItem: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
                .frame(width: 30, height: 30)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

struct TransactionRow: View {
    let title: String
    let subtitle: String
    let amount: String
    let time: String
    let isDebit: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(isDebit ? Color.errorRed.opacity(0.1) : Color.primaryGreen.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: isDebit ? "arrow.up.right" : "arrow.down.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isDebit ? .errorRed : .primaryGreen)
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
                Text(amount)
                    .font(.headline)
                    .foregroundColor(isDebit ? .errorRed : .primaryGreen)
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

// MARK: - BankCardView
struct BankCardView: View {
    let card: BankCard
    @State private var isBalanceHidden = false
    
    var body: some View {
        ZStack {
            // Card Background with Gradient
            LinearGradient(
                gradient: Gradient(colors: card.gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Card Pattern/Texture Overlay
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.1),
                            Color.clear,
                            Color.black.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Card Content
            VStack(alignment: .leading, spacing: 0) {
                // Top Row - Bank Name and Card Type
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(card.bankName)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(card.textColor)
                        
                        Text(card.cardType.rawValue.uppercased())
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(card.textColor.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    // Bank Logo Placeholder or Chip
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 32, height: 24)
                        .overlay(
                            Image(systemName: "creditcard.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
                // Balance Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Available Balance")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(card.textColor.opacity(0.8))
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isBalanceHidden.toggle()
                            }
                        }) {
                            Image(systemName: isBalanceHidden ? "eye" : "eye.slash")
                                .font(.system(size: 10))
                                .foregroundColor(card.textColor.opacity(0.7))
                        }
                        
                        Spacer()
                    }
                    
                    Text(isBalanceHidden ? "₹ ••••••" : "₹\(card.balance, specifier: "%.2f")")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(card.textColor)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Bottom Row - Card Number and Expiry
                VStack(alignment: .leading, spacing: 8) {
                    Text(card.maskedCardNumber)
                        .font(.system(size: 16, weight: .medium, design: .monospaced))
                        .foregroundColor(card.textColor)
                        .tracking(1.5)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("CARD HOLDER")
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(card.textColor.opacity(0.7))
                            
                            Text(card.cardHolderName)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(card.textColor)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("VALID THRU")
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(card.textColor.opacity(0.7))
                            
                            Text(card.expiryDate)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(card.textColor)
                        }
                        
                        // Card Network Logo (Visa/Mastercard placeholder)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white)
                            .frame(width: 40, height: 24)
                            .overlay(
                                Text(card.cardType == .credit ? "VISA" : "MC")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.blue)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
        .frame(height: 200)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

// MARK: - CardCarouselView
struct CardCarouselView: View {
    let cards: [BankCard]
    @State private var currentCardIndex = 0
    
    var body: some View {
        VStack(spacing: 16) {
            // Card Carousel
            TabView(selection: $currentCardIndex) {
                ForEach(cards.indices, id: \.self) { index in
                    BankCardView(card: cards[index])
                        .padding(.horizontal, 4)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 200)
            .animation(.easeInOut(duration: 0.4), value: currentCardIndex)
            
            // Custom Page Indicators
            HStack(spacing: 8) {
                ForEach(cards.indices, id: \.self) { index in
                    Circle()
                        .fill(index == currentCardIndex ? Color.primaryGreen : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentCardIndex ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: currentCardIndex)
                }
            }
            .padding(.bottom, 8)
            
            // Card Info
            if !cards.isEmpty {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(cards[currentCardIndex].bankName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                        
                        Text("\(cards[currentCardIndex].cardType.rawValue) Card")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Quick Balance Toggle for Current Card
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Current Balance")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text("₹\(cards[currentCardIndex].balance, specifier: "%.2f")")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryGreen)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
            }
        }
    }
}

// MARK: - HorizontalActionsCard
struct HorizontalActionsCardAlt: View {
    let onSendMoneyTap: () -> Void
    let onCheckBalanceTap: () -> Void
    let onSendToSelfTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Money Transfer")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button("View All") {
                    // Handle view all action
                }
                .font(.caption)
                .foregroundColor(.primaryGreen)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            // Horizontal Buttons
            HStack(spacing: 0) {
                ActionButtonCompact(
                    title: "Send Money",
                    subtitle: "To any number",
                    icon: "paperplane.fill",
                    action: onSendMoneyTap
                )
                
                Divider()
                    .frame(height: 60)
                
                ActionButtonCompact(
                    title: "Check Balance",
                    subtitle: "View details",
                    icon: "eye.fill",
                    action: onCheckBalanceTap
                )
                
                Divider()
                    .frame(height: 60)
                
                ActionButtonCompact(
                    title: "Self Transfer",
                    subtitle: "Between accounts",
                    icon: "arrow.2.squarepath",
                    action: onSendToSelfTap
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct ActionButtonCompact: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primaryGreen)
                    .frame(width: 32, height: 32)
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    Text(subtitle)
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.textSecondary)
                }
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        HomeView(isPreview: true)
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    .environmentObject(AuthStateManager(isPreview: true))
}
