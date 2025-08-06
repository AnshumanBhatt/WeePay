//
//  MetroTicketView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 24/07/25.
//

import SwiftUI

struct MetroTicketView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Metro Ticket Booking")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text("Coming Soon")
                    .font(.headline)
                    .foregroundColor(.textSecondary)
                    .padding(.top, 8)
                
                Spacer()
            }
            .navigationTitle("Book Metro Ticket")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MetroTicketView()
}
