//
//  BankCard.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 15/07/25.
//

import SwiftUI

struct BankCard: Identifiable, Hashable {
    let id = UUID()
    let bankName: String
    let cardType: CardType
    let cardNumber: String
    let balance: Double
    let cardHolderName: String
    let expiryDate: String
    let gradientColors: [Color]
    let textColor: Color
    let logoName: String? // For bank logo if available
    
    enum CardType: String, CaseIterable {
        case debit = "Debit"
        case credit = "Credit"
        case prepaid = "Prepaid"
    }
    
    // Masked card number for display (showing only last 4 digits)
    var maskedCardNumber: String {
        let lastFour = String(cardNumber.suffix(4))
        return "**** **** **** \(lastFour)"
    }
    
    // Static sample cards for demo
    static let sampleCards: [BankCard] = [
        BankCard(
            bankName: "State Bank of India",
            cardType: .debit,
            cardNumber: "1234567812345678",
            balance: 12547.50,
            cardHolderName: "ANSHUMAN BHATT",
            expiryDate: "12/27",
            gradientColors: [
                Color(red: 0.1, green: 0.3, blue: 0.8),
                Color(red: 0.2, green: 0.5, blue: 0.9)
            ],
            textColor: .white,
            logoName: "sbi_logo"
        ),
        BankCard(
            bankName: "HDFC Bank",
            cardType: .credit,
            cardNumber: "9876543298765432",
            balance: 85000.00,
            cardHolderName: "ANSHUMAN BHATT",
            expiryDate: "05/26",
            gradientColors: [
                Color(red: 0.8, green: 0.1, blue: 0.1),
                Color(red: 0.9, green: 0.3, blue: 0.3)
            ],
            textColor: .white,
            logoName: "hdfc_logo"
        ),
        BankCard(
            bankName: "ICICI Bank",
            cardType: .debit,
            cardNumber: "5555444433332222",
            balance: 5420.75,
            cardHolderName: "ANSHUMAN BHATT",
            expiryDate: "08/25",
            gradientColors: [
                Color(red: 0.9, green: 0.4, blue: 0.0),
                Color(red: 1.0, green: 0.6, blue: 0.2)
            ],
            textColor: .white,
            logoName: "icici_logo"
        ),
        BankCard(
            bankName: "Axis Bank",
            cardType: .debit,
            cardNumber: "4444333322221111",
            balance: 28950.30,
            cardHolderName: "ANSHUMAN BHATT",
            expiryDate: "03/28",
            gradientColors: [
                Color(red: 0.5, green: 0.0, blue: 0.5),
                Color(red: 0.7, green: 0.2, blue: 0.7)
            ],
            textColor: .white,
            logoName: "axis_logo"
        )
    ]
}
