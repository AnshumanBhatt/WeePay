//
//  FAQView.swift
//  WeePay
//
//  Created by Preview Stub
//

import SwiftUI

struct FAQView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Frequently Asked Questions")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .padding(.top, 20)
                
                VStack(spacing: 16) {
                    FAQItem(
                        question: "How do I send money?",
                        answer: "Tap on 'Send Money' from the home screen and enter the recipient's phone number."
                    )
                    
                    FAQItem(
                        question: "Is my money safe?",
                        answer: "Yes, WeePay uses bank-grade security to protect your funds."
                    )
                    
                    FAQItem(
                        question: "How do I add money to my wallet?",
                        answer: "Tap 'Add Money' and choose your preferred payment method."
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .background(Color.lightGreen.ignoresSafeArea())
        .navigationTitle("FAQ")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FAQItem: View {
    let question: String
    let answer: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(question)
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.primaryGreen)
                }
            }
            
            if isExpanded {
                Text(answer)
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        FAQView()
    }
}
