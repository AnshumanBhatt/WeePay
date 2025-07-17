//
//  SupabaseConfig.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 16/07/25.
//

import Foundation

struct SupabaseConfig {
    // Replace these with your actual Supabase project credentials
    static let url = "https://your-project-id.supabase.co"
    static let anonKey = "your-anon-key-here"
    
    // You can also use environment variables for better security
    // static let url = ProcessInfo.processInfo.environment["SUPABASE_URL"] ?? ""
    // static let anonKey = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"] ?? ""
}
