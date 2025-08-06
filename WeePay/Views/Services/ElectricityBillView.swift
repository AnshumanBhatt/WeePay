//
//  ElectricityBillView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 24/07/25.
//

import SwiftUI

struct ElectricityBillView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Electricity Bill Payment")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text("Coming Soon")
                    .font(.headline)
                    .foregroundColor(.textSecondary)
                    .padding(.top, 8)
                
                Spacer()
            }
            .navigationTitle("Pay Electricity Bill")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ElectricityBillView()
}
