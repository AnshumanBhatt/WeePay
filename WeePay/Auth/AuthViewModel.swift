//
//  AuthViewModel.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 16/07/25.
//

import SwiftUI
import Combine
import Supabase

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
    
    private let supabase = SupabaseClient(
        supabaseURL: URL(string: SupabaseConfig.url)!,
        supabaseKey: SupabaseConfig.anonKey
    )
    
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
        
        isLoading = true
        
        do {
            try await supabase.auth.signInWithOTP(
                phone: formatPhoneNumber(phoneNumber)
            )
            currentStep = .otpVerification
        } catch {
            showErrorMessage("Failed to send OTP: \(error.localizedDescription)")
        }
        
        isLoading = false
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
        
        isLoading = true
        
        do {
            try await supabase.auth.signInWithOTP(
                phone: formatPhoneNumber(phoneNumber)
            )
            currentStep = .otpVerification
        } catch {
            showErrorMessage("Failed to send OTP: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // MARK: - Verify OTP
    func verifyOTP() async {
        guard !otpCode.isEmpty else {
            showErrorMessage("Please enter the OTP code")
            return
        }
        
        isLoading = true
        
        do {
            try await supabase.auth.verifyOTP(
                phone: formatPhoneNumber(phoneNumber),
                token: otpCode,
                type: .sms
            )
            
            // If this is a sign up, update the user profile with name
            if isSignUp {
                try await updateUserProfile()
            }
            
            isAuthenticated = true
            currentStep = .completed
        } catch {
            showErrorMessage("Invalid OTP code. Please try again.")
        }
        
        isLoading = false
    }
    
    // MARK: - Update User Profile
    private func updateUserProfile() async throws {
        try await supabase.auth.update(
            user: UserAttributes(
                data: ["name": AnyJSON.string(name)]
            )
        )
    }
    
    // MARK: - Check Auth Status
    func checkAuthStatus() async {
        do {
            let session = try await supabase.auth.session
            isAuthenticated = session.user != nil
        } catch {
            isAuthenticated = false
        }
    }
    
    // MARK: - Sign Out
    func signOut() async {
        do {
            try await supabase.auth.signOut()
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
