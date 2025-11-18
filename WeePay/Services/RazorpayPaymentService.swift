//
//  RazorpayPaymentService.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 17/11/25.
//

import Foundation
import UIKit
import Razorpay

class RazorpayPaymentService: NSObject {
    
    @MainActor static let shared = RazorpayPaymentService()
    private var razorpay: RazorpayCheckout?
    private var paymentCompletion: ((Bool, String?) -> Void)?
    
    private override init() {
        super.init()
        setupRazorpay()
    }
    
    private func setupRazorpay() {
        razorpay = RazorpayCheckout.initWithKey(RazorpayConfig.keyID, andDelegate: self)
    }
    
    @MainActor
    func makePayment(for details: PaymentDetails, amount: Double, completion: @escaping (Bool, String?) -> Void) {
        self.paymentCompletion = completion
        
        let options: [String: Any] = [
            "description": "Payment to \(details.merchantName)",
            "image": "https://rzp-mobile.s3.amazonaws.com/images/rzp.png",
            "name": details.merchantName,
            "prefill": [
                "contact": "9999999999",
                "email": "customer@example.com"
            ],
            "theme": [
                "color": "#3399cc"
            ],
            "amount": amount * 100, // Convert to paise
            "currency": "INR",
            "notes": [
                "qr_string": details.qrString,
                "upi_id": details.upiID ?? ""
            ]
        ]
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            razorpay?.open(options, displayController: rootViewController)
        }
    }
    
    @MainActor
    func makeUPIPayment(for details: PaymentDetails, amount: Double, completion: @escaping (Bool, String?) -> Void) {
        self.paymentCompletion = completion
        
        // For UPI payments, we can create a custom flow
        // or use Razorpay's UPI specific options
        let options: [String: Any] = [
            "description": "UPI Payment to \(details.merchantName)",
            "name": details.merchantName,
            "amount": amount * 100,
            "currency": "INR",
            "method": "upi",
            "vpa": details.upiID ?? "",
            "notes": [
                "qr_string": details.qrString,
                "payment_type": "upi_qr"
            ]
        ]
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            razorpay?.open(options, displayController: rootViewController)
        }
    }
}

// MARK: - RazorpayPaymentCompletionProtocol
extension RazorpayPaymentService: RazorpayPaymentCompletionProtocol {
    
    @objc func onPaymentError(_ code: Int32, description str: String) {
        let completion = paymentCompletion
        paymentCompletion = nil
        
       
            completion?(false, "Payment Failed: \(str)")
        
    }
    
    @objc func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]) {
        let completion = paymentCompletion
        paymentCompletion = nil
        
        
            completion?(false, "Payment Failed: \(str)")
        
    }
    
    @objc func onPaymentSuccess(_ payment_id: String) {
        let completion = paymentCompletion
        paymentCompletion = nil
        
   
            completion?(true, "Payment Successful: \(payment_id)")
        
    }
    
    @objc func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]) {
        let completion = paymentCompletion
        paymentCompletion = nil
        
        
            completion?(true, "Payment Successful: \(payment_id)")
        
    }
}
