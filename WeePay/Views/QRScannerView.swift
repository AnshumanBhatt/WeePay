//
//  QRScannerView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 15/07/25.
//

import SwiftUI

struct QRScannerView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Image(systemName: "qrcode.viewfinder")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundColor(.primaryGreen)
                
            Text("Scan a QR Code")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)

            Text("Align the QR code within the frame to scan.")
                .font(.subheadline)
                .foregroundColor(.textSecondary)

            Spacer()
        }
        .padding(40)
        .navigationBarTitle("QR Code Scanner", displayMode: .inline)
        .background(Color.lightGreen.ignoresSafeArea())
    }
}

#Preview {
    QRScannerView()
}

