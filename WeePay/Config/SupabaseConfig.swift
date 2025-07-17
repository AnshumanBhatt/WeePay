//
//  SupabaseConfig.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 16/07/25.
//

import Foundation

struct SupabaseConfig {
    // Replace these with your actual Supabase project credentials
    static let url = "https://eioktepbtacunfzhktzr.supabase.co"
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVpb2t0ZXBidGFjdW5memhrdHpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE1NDI1NzQsImV4cCI6MjA2NzExODU3NH0.I0p8legCHSaGx3XU2pRnZQrjVCikybrPhSBLwInvs9g"
    
    // You can also use environment variables for better security
    // static let url = ProcessInfo.processInfo.environment["SUPABASE_URL"] ?? ""
    // static let anonKey = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"] ?? ""
}
