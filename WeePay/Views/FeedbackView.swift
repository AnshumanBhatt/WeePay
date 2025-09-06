//
//  FeedbackView.swift
//  WeePay
//
//  Created by Preview Stub
//

import SwiftUI

struct FeedbackView: View {
    @State private var feedbackText = ""
    @State private var rating = 5
    @State private var showingSuccess = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Send Feedback")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Rate your experience")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { star in
                            Button(action: { rating = star }) {
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .font(.title2)
                                    .foregroundColor(star <= rating ? .yellow : .gray)
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tell us more")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    TextEditor(text: $feedbackText)
                        .frame(height: 120)
                        .padding(12)
                        .background(Color.softGray.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.primaryGreen.opacity(0.3), lineWidth: 1)
                        )
                    
                    if feedbackText.isEmpty {
                        Text("Share your thoughts, suggestions, or report issues...")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .padding(.leading, 12)
                            .padding(.top, -120)
                            .allowsHitTesting(false)
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
                
                Button(action: {
                    showingSuccess = true
                }) {
                    Text("Submit Feedback")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.primaryGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .primaryGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(feedbackText.isEmpty)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.lightGreen.ignoresSafeArea())
        .navigationTitle("Feedback")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank You!", isPresented: $showingSuccess) {
            Button("OK") {
                feedbackText = ""
                rating = 5
            }
        } message: {
            Text("Your feedback has been submitted successfully.")
        }
    }
}

#Preview {
    NavigationStack {
        FeedbackView()
    }
}
