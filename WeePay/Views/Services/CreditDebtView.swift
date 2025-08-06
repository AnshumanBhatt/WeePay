//
//  CreditDebtView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 24/07/25.
//

import SwiftUI

struct CreditDebtView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Credit Card Payment")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text("Coming Soon")
                    .font(.headline)
                    .foregroundColor(.textSecondary)
                    .padding(.top, 8)
                
                Spacer()
            }
            .navigationTitle("Pay Credit Debt")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CreditDebtView()
}
