//
//  InvestView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 24/07/25.
//

import SwiftUI

struct InvestView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Investment Services")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text("Coming Soon")
                    .font(.headline)
                    .foregroundColor(.textSecondary)
                    .padding(.top, 8)
                
                Spacer()
            }
            .navigationTitle("Invest")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    InvestView()
}
