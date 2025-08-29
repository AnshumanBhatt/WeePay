//
//  ExpenseCategoryModel.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 26/08/25.
//

import Foundation
import SwiftUI

struct ExpenseCategoryModel: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let colorHex: String
    
    static let defaultCategories: [ExpenseCategoryModel] = [
        ExpenseCategoryModel(name: "Food", icon: "fork.knife", color: .orange, colorHex: "#FF9500"),
        ExpenseCategoryModel(name: "Travel", icon: "car.fill", color: .blue, colorHex: "#007AFF"),
        ExpenseCategoryModel(name: "Shopping", icon: "bag.fill", color: .pink, colorHex: "#FF2D92"),
        ExpenseCategoryModel(name: "Bills", icon: "doc.text.fill", color: .red, colorHex: "#FF3B30"),
        ExpenseCategoryModel(name: "Entertainment", icon: "tv.fill", color: .purple, colorHex: "#AF52DE"),
        ExpenseCategoryModel(name: "Healthcare", icon: "cross.fill", color: .green, colorHex: "#34C759"),
        ExpenseCategoryModel(name: "Education", icon: "book.fill", color: .indigo, colorHex: "#5856D6"),
        ExpenseCategoryModel(name: "Fuel", icon: "fuelpump.fill", color: .brown, colorHex: "#A2845E"),
        ExpenseCategoryModel(name: "Grocery", icon: "cart.fill", color: .mint, colorHex: "#00C7BE"),
        ExpenseCategoryModel(name: "Rent", icon: "house.fill", color: .cyan, colorHex: "#32D74B"),
        ExpenseCategoryModel(name: "Income", icon: "arrow.down.circle.fill", color: .primaryGreen, colorHex: "#10B981"),
        ExpenseCategoryModel(name: "Other", icon: "ellipsis.circle.fill", color: .gray, colorHex: "#8E8E93")
    ]
    
    static func getCategoryByName(_ name: String) -> ExpenseCategoryModel {
        return defaultCategories.first { $0.name == name } ?? defaultCategories.last!
    }
    
    static func getCategoryColor(_ name: String) -> Color {
        return getCategoryByName(name).color
    }
    
    static func getCategoryIcon(_ name: String) -> String {
        return getCategoryByName(name).icon
    }
}

// MARK: - Transaction Type Enum
enum TransactionType: String, CaseIterable {
    case expense = "expense"
    case income = "income"
    case payment = "payment"
    
    var displayName: String {
        switch self {
        case .expense:
            return "Expense"
        case .income:
            return "Income"
        case .payment:
            return "Payment"
        }
    }
}

// MARK: - Payment Method Enum
enum PaymentMethod: String, CaseIterable {
    case cash = "cash"
    case card = "card"
    case upi = "upi"
    case netBanking = "net_banking"
    case wallet = "wallet"
    
    var displayName: String {
        switch self {
        case .cash:
            return "Cash"
        case .card:
            return "Card"
        case .upi:
            return "UPI"
        case .netBanking:
            return "Net Banking"
        case .wallet:
            return "Wallet"
        }
    }
    
    var icon: String {
        switch self {
        case .cash:
            return "banknote.fill"
        case .card:
            return "creditcard.fill"
        case .upi:
            return "qrcode"
        case .netBanking:
            return "building.columns.fill"
        case .wallet:
            return "wallet.pass.fill"
        }
    }
}
