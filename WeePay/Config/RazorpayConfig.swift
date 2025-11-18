//
//  RazorpayConfig.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 17/11/25.
//

import Foundation
import Razorpay

class RazorpayConfig: NSObject {
    
    // Replace with your actual Razorpay Key ID from Razorpay Dashboard
    // Test key: rzp_test_XXXXXXXXXXXXXXXX
    // Live key: rzp_live_XXXXXXXXXXXXXXXX
    static let keyID = "rzp_test_RgnPHa7rty77E7"
    
    static func createRazorpayInstance() -> RazorpayCheckout {
        return RazorpayCheckout.initWithKey(keyID)
    }
    
    static func validateQRCode(_ qrString: String) -> Bool {
        // Razorpay QR codes typically contain UPI payment URLs
        // or specific Razorpay payment identifiers
        return qrString.contains("upi://") || 
               qrString.contains("razorpay") ||
               qrString.hasPrefix("https://rzp.io") ||
               qrString.contains("pay")
    }
    
    static func extractPaymentDetails(from qrString: String) -> PaymentDetails? {
        // Parse QR code to extract payment information
        if qrString.contains("upi://") {
            return parseUPIURL(qrString)
        } else if qrString.hasPrefix("https://rzp.io") {
            return parseRazorpayURL(qrString)
        }
        return nil
    }
    
    private static func parseUPIURL(_ url: String) -> PaymentDetails? {
        // Parse UPI URL to extract merchant info
        let components = URLComponents(string: url)
        var merchantName = "Unknown Merchant"
        var amount: Double? = nil
        
        if let queryItems = components?.queryItems {
            for item in queryItems {
                if item.name == "pn" {
                    merchantName = item.value ?? "Unknown Merchant"
                } else if item.name == "am" {
                    amount = Double(item.value ?? "0") ?? 0 / 100.0 // Convert paise to rupees
                }
            }
        }
        
        return PaymentDetails(
            merchantName: merchantName,
            upiID: extractUPIID(from: url),
            amount: amount,
            qrString: url
        )
    }
    
    private static func parseRazorpayURL(_ url: String) -> PaymentDetails? {
        // Parse Razorpay payment link
        return PaymentDetails(
            merchantName: "Razorpay Payment",
            upiID: nil,
            amount: nil,
            qrString: url
        )
    }
    
    private static func extractUPIID(from url: String) -> String? {
        // Extract UPI ID from UPI URL
        if let paRange = url.range(of: "pa=") {
            let startIndex = paRange.upperBound
            if let endIndex = url[startIndex...].firstIndex(of: "&") {
                return String(url[startIndex..<endIndex])
            } else {
                return String(url[startIndex...])
            }
        }
        return nil
    }
}

struct PaymentDetails {
    let merchantName: String
    let upiID: String?
    let amount: Double?
    let qrString: String
}
