//
//  PaymentView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 17/11/25.
//

import SwiftUI

struct PaymentView: View {
    let paymentDetails: PaymentDetails
    let onCompletion: () -> Void
    
    @State private var amount: String = ""
    @State private var isProcessing = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var paymentSuccess = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Merchant Info
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.primaryGreen)
                    
                    Text(paymentDetails.merchantName)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let upiID = paymentDetails.upiID {
                        Text(upiID)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                
                // Amount Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter Amount")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text("₹")
                            .font(.title)
                            .foregroundColor(.primaryGreen)
                        
                        TextField("0.00", text: $amount)
                            .font(.title)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    if let suggestedAmount = paymentDetails.amount {
                        Text("Suggested: ₹\(String(format: "%.2f", suggestedAmount))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .onTapGesture {
                                amount = String(format: "%.2f", suggestedAmount)
                            }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Pay Button
                Button(action: processPayment) {
                    HStack {
                        if isProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        
                        Text(isProcessing ? "Processing..." : "Pay ₹\(amount.isEmpty ? "0.00" : amount)")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isProcessing || amount.isEmpty || Double(amount) == nil ? Color.gray : Color.primaryGreen)
                    .cornerRadius(12)
                }
                .disabled(isProcessing || amount.isEmpty || Double(amount) == nil)
                .padding(.horizontal)
                
                // Cancel Button
                Button("Cancel") {
                    onCompletion()
                }
                .foregroundColor(.red)
                .padding()
            }
            .navigationBarHidden(true)
        }
        .alert("Payment Status", isPresented: $showingAlert) {
            Button("OK") {
                if paymentSuccess {
                    onCompletion()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func processPayment() {
        guard let paymentAmount = Double(amount), paymentAmount > 0 else {
            alertMessage = "Please enter a valid amount"
            showingAlert = true
            return
        }
        
        isProcessing = true
        
        // Use Razorpay service to process payment
        RazorpayPaymentService.shared.makePayment(for: paymentDetails, amount: paymentAmount) { success, message in
            DispatchQueue.main.async {
                self.isProcessing = false
                self.paymentSuccess = success
                self.alertMessage = message ?? "Payment completed"
                self.showingAlert = true
            }
        }
    }
}

#Preview {
    PaymentView(
        paymentDetails: PaymentDetails(
            merchantName: "Test Merchant",
            upiID: "test@upi",
            amount: 100.0,
            qrString: "upi://pay?pa=test@upi&pn=Test%20Merchant&am=10000"
        ),
        onCompletion: {}
    )
}
