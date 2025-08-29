//
//  PaymentMethodPickerView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 26/08/25.
//

import SwiftUI

struct PaymentMethodPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedPaymentMethod: PaymentMethod
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lightGreen.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ForEach(PaymentMethod.allCases, id: \.rawValue) { method in
                        PaymentMethodItem(
                            method: method,
                            isSelected: selectedPaymentMethod == method
                        ) {
                            selectedPaymentMethod = method
                            dismiss()
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Payment Method")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryGreen)
                }
            }
        }
    }
}

struct PaymentMethodItem: View {
    let method: PaymentMethod
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: method.icon)
                    .font(.title2)
                    .foregroundColor(.primaryGreen)
                    .frame(width: 32, height: 32)
                    .background(Color.primaryGreen.opacity(0.1))
                    .clipShape(Circle())
                
                Text(method.displayName)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.primaryGreen)
                }
            }
            .padding(20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.primaryGreen : Color.clear, lineWidth: 2)
            )
            .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

#Preview {
    PaymentMethodPickerView(selectedPaymentMethod: .constant(.cash))
}
