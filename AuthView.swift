//
//  AuthView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 16/07/25.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            // Background
            Color.lightGreen
                .ignoresSafeArea()
            
            VStack {
                switch authViewModel.currentStep {
                case .phoneInput:
                    PhoneInputView(viewModel: authViewModel)
                case .otpVerification:
                    OTPVerificationView(viewModel: authViewModel)
                case .completed:
                    MainTabView()
                }
            }
        }
        .alert("Error", isPresented: $authViewModel.showError) {
            Button("OK") { }
        } message: {
            Text(authViewModel.errorMessage)
        }
        .task {
            await authViewModel.checkAuthStatus()
        }
    }
}

struct PhoneInputView: View {
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var isPhoneFieldFocused: Bool
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            // Logo and Title
            VStack(spacing: 16) {
                Image(systemName: "wallet.pass.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.primaryGreen)
                
                Text("WeePay")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                
                Text(viewModel.isSignUp ? "Create your account" : "Welcome back")
                    .font(.headline)
                    .foregroundColor(.textSecondary)
            }
            .padding(.top, 60)
            
            // Form Container
            VStack(spacing: 24) {
                // Name Field (only for sign up)
                if viewModel.isSignUp {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.textPrimary)
                        
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.textSecondary)
                                .frame(width: 20)
                            
                            TextField("Enter your full name", text: $viewModel.name)
                                .textFieldStyle(PlainTextFieldStyle())
                                .focused($isNameFieldFocused)
                                .textContentType(.name)
                                .autocapitalization(.words)
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                }
                
                // Phone Number Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone Number")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.textPrimary)
                    
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.textSecondary)
                            .frame(width: 20)
                        
                        Text("+91")
                            .foregroundColor(.textSecondary)
                            .fontWeight(.medium)
                        
                        TextField("Enter your phone number", text: $viewModel.phoneNumber)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.phonePad)
                            .focused($isPhoneFieldFocused)
                            .textContentType(.telephoneNumber)
                            .onChange(of: viewModel.phoneNumber) { _, newValue in
                                // Format phone number input
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered.count <= 10 {
                                    viewModel.phoneNumber = filtered
                                }
                            }
                    }
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                
                // Action Button
                Button(action: {
                    Task {
                        if viewModel.isSignUp {
                            await viewModel.signUp()
                        } else {
                            await viewModel.login()
                        }
                    }
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        
                        Text(viewModel.isSignUp ? "Send OTP" : "Login")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.primaryGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .primaryGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(viewModel.isLoading)
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            // Switch between Sign Up and Login
            VStack(spacing: 16) {
                HStack {
                    Rectangle()
                        .fill(Color.softGray)
                        .frame(height: 1)
                    
                    Text("or")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                        .padding(.horizontal, 16)
                    
                    Rectangle()
                        .fill(Color.softGray)
                        .frame(height: 1)
                }
                
                Button(action: {
                    if viewModel.isSignUp {
                        viewModel.switchToLogin()
                    } else {
                        viewModel.switchToSignUp()
                    }
                }) {
                    HStack {
                        Text(viewModel.isSignUp ? "Already have an account?" : "Don't have an account?")
                            .foregroundColor(.textSecondary)
                        
                        Text(viewModel.isSignUp ? "Login" : "Sign Up")
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryGreen)
                    }
                    .font(.subheadline)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .onTapGesture {
            isPhoneFieldFocused = false
            isNameFieldFocused = false
        }
    }
}

struct OTPVerificationView: View {
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var isOTPFieldFocused: Bool
    @State private var timeRemaining = 60
    @State private var canResend = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 32) {
            // Back Button
            HStack {
                Button(action: {
                    viewModel.goBackToPhoneInput()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primaryGreen)
                }
                
                Spacer()
            }
            .padding(.horizontal, 32)
            .padding(.top, 60)
            
            // Title and Instructions
            VStack(spacing: 16) {
                Image(systemName: "message.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.primaryGreen)
                
                Text("Verify Your Number")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                VStack(spacing: 8) {
                    Text("We've sent a verification code to")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    Text("+91 \(viewModel.phoneNumber)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                }
            }
            
            // OTP Input
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter OTP")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.textPrimary)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.textSecondary)
                            .frame(width: 20)
                        
                        TextField("Enter 6-digit code", text: $viewModel.otpCode)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.numberPad)
                            .focused($isOTPFieldFocused)
                            .textContentType(.oneTimeCode)
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .onChange(of: viewModel.otpCode) { _, newValue in
                                // Limit to 6 digits
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered.count <= 6 {
                                    viewModel.otpCode = filtered
                                }
                            }
                    }
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                
                // Verify Button
                Button(action: {
                    Task {
                        await viewModel.verifyOTP()
                    }
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        
                        Text("Verify OTP")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.primaryGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .primaryGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(viewModel.isLoading || viewModel.otpCode.count != 6)
            }
            .padding(.horizontal, 32)
            
            // Resend OTP
            VStack(spacing: 12) {
                if canResend {
                    Button(action: {
                        Task {
                            await viewModel.resendOTP()
                            timeRemaining = 60
                            canResend = false
                        }
                    }) {
                        Text("Resend OTP")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryGreen)
                    }
                } else {
                    Text("Resend code in \(timeRemaining)s")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }
            }
            
            Spacer()
        }
        .onAppear {
            isOTPFieldFocused = true
            timeRemaining = 60
            canResend = false
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                canResend = true
            }
        }
        .onTapGesture {
            isOTPFieldFocused = false
        }
    }
}

#Preview {
    AuthView()
}
