//
//  AuthViewModel.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 16/07/25.
//

import SwiftUI
import Combine
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showError = false
    @Published var currentStep: AuthStep = .phoneInput
    @Published var phoneNumber = ""
    @Published var name = ""
    @Published var otpCode = ""
    @Published var isSignUp = false
    
    private var verificationID: String?
    
    enum AuthStep {
        case phoneInput
        case otpVerification
        case completed
    }
    
    // MARK: - Sign Up
    func signUp() async {
        guard !phoneNumber.isEmpty && !name.isEmpty else {
            showErrorMessage("Please fill in all fields")
            return
        }
        
        guard isValidPhoneNumber(phoneNumber) else {
            showErrorMessage("Please enter a valid phone number")
            return
        }
        
        await sendOTP()
    }
    
    // MARK: - Login
    func login() async {
        guard !phoneNumber.isEmpty else {
            showErrorMessage("Please enter your phone number")
            return
        }
         
        guard isValidPhoneNumber(phoneNumber) else {
            showErrorMessage("Please enter a valid phone number")
            return
        }
        
        await sendOTP()
    }
    
    // MARK: - Send OTP
    private func sendOTP() async {
        isLoading = true
        
        do {
            let result = try await PhoneAuthProvider.provider().verifyPhoneNumber(
                formatPhoneNumber(phoneNumber),
                uiDelegate: nil
            )
            
            verificationID = result
            currentStep = .otpVerification
        } catch let error as NSError {
            let errorMessage: String
            
            // Handle specific Firebase Auth error codes
            if let authErrorCode = AuthErrorCode(rawValue: error.code) {
                switch authErrorCode {
                case .quotaExceeded:
                    errorMessage = "SMS quota exceeded. Please try again later."
                case .invalidPhoneNumber:
                    errorMessage = "Invalid phone number format."
                case .missingPhoneNumber:
                    errorMessage = "Please enter a phone number."
                case .captchaCheckFailed:
                    errorMessage = "Captcha verification failed. Please try again."
                case .networkError:
                    errorMessage = "Network error. Please check your connection and try again."
                case .tooManyRequests:
                    errorMessage = "Too many requests. Please wait a moment and try again."
                default:
                    errorMessage = "Failed to send OTP: \(error.localizedDescription)"
                }
            } else {
                errorMessage = "Failed to send OTP. Please check your internet connection and try again."
            }
            
            showErrorMessage(errorMessage)
        }
        
        isLoading = false
    }
    
    // MARK: - Verify OTP
    func verifyOTP() async {
        guard !otpCode.isEmpty else {
            showErrorMessage("Please enter the OTP code")
            return
        }
        
        guard let verificationID = verificationID else {
            showErrorMessage("Verification ID not found. Please try again.")
            return
        }
        
        isLoading = true
        
        do {
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: otpCode
            )
            
            let result = try await Auth.auth().signIn(with: credential)
            
            // If this is a sign up, update the user profile with name
            if isSignUp {
                try await updateUserProfile(user: result.user)
            }
            
            isAuthenticated = true
            currentStep = .completed
        } catch {
            showErrorMessage("Invalid OTP code. Please try again.")
        }
        
        isLoading = false
    }
    
    // MARK: - Update User Profile
    private func updateUserProfile(user: User) async throws {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
    }
    
    // MARK: - Check Auth Status
    func checkAuthStatus() async {
        if let currentUser = Auth.auth().currentUser {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
    
    // MARK: - Sign Out
    func signOut() async {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            resetAuthState()
        } catch {
            showErrorMessage("Failed to sign out")
        }
    }
    
    // MARK: - Resend OTP
    func resendOTP() async {
        await (isSignUp ? signUp() : login())
    }
    
    // MARK: - Helper Methods
    private func formatPhoneNumber(_ phone: String) -> String {
        let cleaned = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return cleaned.hasPrefix("91") ? "+\(cleaned)" : "+91\(cleaned)"
    }
    
    private func isValidPhoneNumber(_ phone: String) -> Bool {
        let cleaned = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return cleaned.count == 10 || (cleaned.count == 12 && cleaned.hasPrefix("91"))
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    private func resetAuthState() {
        currentStep = .phoneInput
        phoneNumber = ""
        name = ""
        otpCode = ""
        isSignUp = false
        errorMessage = ""
        showError = false
    }
    
    // MARK: - Navigation
    func switchToSignUp() {
        isSignUp = true
        resetFields()
    }
    
    func switchToLogin() {
        isSignUp = false
        resetFields()
    }
    
    func goBackToPhoneInput() {
        currentStep = .phoneInput
        otpCode = ""
    }
    
    private func resetFields() {
        phoneNumber = ""
        name = ""
        otpCode = ""
        errorMessage = ""
        showError = false
        currentStep = .phoneInput
    }
}
