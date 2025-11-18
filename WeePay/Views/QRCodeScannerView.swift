//
//  QRCodeScannerView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 24/07/25.
//

import SwiftUI
import AVFoundation

struct QRCodeScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var scannedCode: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingPaymentSheet = false
    @State private var paymentDetails: PaymentDetails?
    @State private var shouldRestartCamera = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Camera view
                QRScannerCameraView(
                    scannedCode: $scannedCode, 
                    showingAlert: $showingAlert, 
                    alertMessage: $alertMessage,
                    showingPaymentSheet: $showingPaymentSheet,
                    paymentDetails: $paymentDetails,
                    shouldRestartCamera: $shouldRestartCamera
                )
                    .ignoresSafeArea()
                
                // Overlay UI
                VStack {
                    // Top section
                    VStack(spacing: 16) {
                        Text("Scan QR Code")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Point your camera at a QR code to scan")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 60)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Scanning frame
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.primaryGreen, lineWidth: 3)
                            .frame(width: 250, height: 250)
                        
                        // Corner indicators
                        VStack {
                            HStack {
                                Rectangle()
                                    .fill(Color.primaryGreen)
                                    .frame(width: 30, height: 6)
                                    .offset(x: 15, y: 15)
                                Spacer()
                                Rectangle()
                                    .fill(Color.primaryGreen)
                                    .frame(width: 30, height: 6)
                                    .offset(x: -15, y: 15)
                            }
                            Spacer()
                            HStack {
                                Rectangle()
                                    .fill(Color.primaryGreen)
                                    .frame(width: 30, height: 6)
                                    .offset(x: 15, y: -15)
                                Spacer()
                                Rectangle()
                                    .fill(Color.primaryGreen)
                                    .frame(width: 30, height: 6)
                                    .offset(x: -15, y: -15)
                            }
                        }
                        .frame(width: 250, height: 250)
                    }
                    
                    Spacer()
                    
                    // Bottom section
                    VStack(spacing: 20) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Cancel")
                                .font(.headline)
                                .foregroundColor(.primaryGreen)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
            .navigationBarHidden(true)
        }
        .alert("QR Code Scanned", isPresented: $showingAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text(alertMessage)
        }
        .sheet(isPresented: $showingPaymentSheet) {
            if let details = paymentDetails {
                PaymentView(paymentDetails: details) {
                    shouldRestartCamera = true
                    showingPaymentSheet = false
                }
            }
        }
        .onChange(of: shouldRestartCamera) { _ in
            if shouldRestartCamera {
                shouldRestartCamera = false
                // Reset scanner state
                scannedCode = ""
                paymentDetails = nil
            }
        }
    }
}

// MARK: - Camera View
struct QRScannerCameraView: UIViewRepresentable {
    @Binding var scannedCode: String
    @Binding var showingAlert: Bool
    @Binding var alertMessage: String
    @Binding var showingPaymentSheet: Bool
    @Binding var paymentDetails: PaymentDetails?
    @Binding var shouldRestartCamera: Bool
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return view
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return view
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return view
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return view
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
        
        context.coordinator.captureSession = captureSession
        context.coordinator.previewLayer = previewLayer
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let previewLayer = context.coordinator.previewLayer else { return }
        previewLayer.frame = uiView.layer.bounds
        
        // Restart camera if needed
        if shouldRestartCamera {
            context.coordinator.restartCamera()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        let parent: QRScannerCameraView
        var captureSession: AVCaptureSession?
        var previewLayer: AVCaptureVideoPreviewLayer?
        var hasScanned = false
        
        init(_ parent: QRScannerCameraView) {
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            // Prevent multiple scans
            if hasScanned { return }
            
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                
                hasScanned = true
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                self.parent.scannedCode = stringValue
                
                // Check if this is a valid Razorpay payment QR code
                if RazorpayConfig.validateQRCode(stringValue) {
                    if let details = RazorpayConfig.extractPaymentDetails(from: stringValue) {
                        self.parent.paymentDetails = details
                        self.parent.showingPaymentSheet = true
                    } else {
                        self.parent.alertMessage = "Invalid payment QR code format"
                        self.parent.showingAlert = true
                    }
                } else {
                    self.parent.alertMessage = "Scanned: \(stringValue)"
                    self.parent.showingAlert = true
                }
                
                // Stop the capture session
                self.captureSession?.stopRunning()
            }
        }
        
        func restartCamera() {
            hasScanned = false
            captureSession?.startRunning()
        }
    }
}

#Preview {
    QRCodeScannerView()
}
