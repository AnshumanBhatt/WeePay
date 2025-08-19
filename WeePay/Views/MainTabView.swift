//
//  MainTabView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 15/07/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            HistoryView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }
                .tag(1)
            
            QRScannerView()
                .tabItem {
                    Image(systemName: "qrcode.viewfinder")
                    Text("QR Scanner")
                }
                .tag(2)
            
            MyMoneyView()
                .tabItem {
                    Image(systemName: "wallet.pass.fill")
                    Text("My Money")
                }
                .tag(3)
        }
        .accentColor(.primaryGreen)
        .onAppear {
            // Customize tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white
            appearance.shadowColor = UIColor.lightGray
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainTabView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AuthStateManager())
}
