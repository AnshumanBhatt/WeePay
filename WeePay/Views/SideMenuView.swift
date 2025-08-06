//
//  SideMenuView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 24/07/25.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background overlay
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    isShowing = false
                }
            
            // Menu content
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    menuHeader
                    
                    // Menu items
                    VStack(spacing: 0) {
                        NavigationLink(destination: FAQView()) {
                            MenuItemView(icon: "questionmark.circle.fill", title: "FAQ")
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        NavigationLink(destination: SettingsView()) {
                            MenuItemView(icon: "gearshape.fill", title: "Settings")
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        NavigationLink(destination: FeedbackView()) {
                            MenuItemView(icon: "message.fill", title: "Feedback")
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .frame(width: 280)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 0))
                .shadow(color: .black.opacity(0.2), radius: 10, x: 5, y: 0)
                
                Spacer()
            }
        }
    }
    
    private var menuHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Button(action: {
                    isShowing = false
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
            }
            .padding(.top, 50)
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Menu")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text("Anshuman Bhatt")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            Divider()
        }
    }
}

struct MenuItemView: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.primaryGreen)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
        .contentShape(Rectangle())
    }
}

#Preview {
    SideMenuView(isShowing: .constant(true))
}
