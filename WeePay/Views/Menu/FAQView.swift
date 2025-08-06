//
//  FAQView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 24/07/25.
//

import SwiftUI

struct FAQView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Frequently Asked Questions")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Coming Soon")
                    .font(.headline)
                    .foregroundColor(.textSecondary)
                    .padding(.top, 8)
                
                Spacer()
            }
            .navigationTitle("FAQ")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
}

#Preview {
    FAQView()
}
