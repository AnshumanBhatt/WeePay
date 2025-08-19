//
//  FeedbackView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 24/07/25.
//

import SwiftUI

struct FeedbackView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Feedback")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text("Coming Soon")
                .font(.headline)
                .foregroundColor(.textSecondary)
                .padding(.top, 8)
            
            Spacer()
        }
        .navigationTitle("Feedback")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FeedbackView()
}
