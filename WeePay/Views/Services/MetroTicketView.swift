//
//  MetroTicketView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 24/07/25.
//

import SwiftUI

struct MetroTicketView: View {
    @State private var fromStation: String = "Millenium City Centre"
    @State private var toStation: String = "Rajeev Chowk"
    @State private var travelDate: Date = Date()
    @State private var passengerCount: Int = 1
    @State private var isReturn: Bool = false
    
    private let recentRoutes: [(from: String, to: String, time: String)] = [
        ("Whitefield", "MG Road", "Yesterday · 6:30 PM"),
        ("Indiranagar", "Majestic", "Sun · 11:10 AM"),
        ("Yeshwanthpur", "Silk Institute", "Sat · 5:45 PM")
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    routeSelectionSection
                    nextMetroSection
                    recentRoutesSection
                    ticketPreviewSection
                }
                .padding(20)
            }
            .background(Color.lightGreen.ignoresSafeArea())
            .navigationTitle("Metro Ticket")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var routeSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Plan your ride")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button {
                    let temp = fromStation
                    fromStation = toStation
                    toStation = temp
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.subheadline)
                        .foregroundColor(.primaryGreen)
                        .padding(8)
                        .background(Color.primaryGreen.opacity(0.08))
                        .clipShape(Circle())
                }
            }
            
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("From")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        HStack {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.primaryGreen)
                            
                            Text(fromStation)
                                .font(.subheadline)
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                        }
                    }
                }
                .padding(12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("To")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 12))
                                .foregroundColor(.errorRed)
                            
                            Text(toStation)
                                .font(.subheadline)
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                        }
                    }
                }
                .padding(12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Date")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    DatePicker("", selection: $travelDate, displayedComponents: [.date])
                        .labelsHidden()
                        .tint(.primaryGreen)
                }
                .padding(12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Passengers")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    HStack(spacing: 8) {
                        Button {
                            passengerCount = max(1, passengerCount - 1)
                        } label: {
                            Image(systemName: "minus")
                                .font(.caption)
                                .foregroundColor(.primaryGreen)
                                .padding(6)
                                .background(Color.primaryGreen.opacity(0.08))
                                .clipShape(Circle())
                        }
                        
                        Text("\(passengerCount)")
                            .font(.subheadline)
                            .foregroundColor(.textPrimary)
                            .frame(minWidth: 24)
                        
                        Button {
                            passengerCount = min(6, passengerCount + 1)
                        } label: {
                            Image(systemName: "plus")
                                .font(.caption)
                                .foregroundColor(.primaryGreen)
                                .padding(6)
                                .background(Color.primaryGreen.opacity(0.08))
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Toggle(isOn: $isReturn) {
                Text("Include return journey")
                    .font(.subheadline)
                    .foregroundColor(.textPrimary)
            }
            .toggleStyle(SwitchToggleStyle(tint: .primaryGreen))
            .padding(.horizontal, 4)
            
            Button {
            } label: {
                HStack {
                    Spacer()
                    Text("Search metro")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.vertical, 12)
                .background(Color.primaryGreen)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var nextMetroSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Next metro")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("Every 7 mins")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("ETA")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("6:42 PM")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                }
                
                Divider()
                    .frame(height: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Platform")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("2 · Purple Line")
                        .font(.subheadline)
                        .foregroundColor(.primaryGreen)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Approx fare")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("₹40 · one way")
                        .font(.subheadline)
                        .foregroundColor(.textPrimary)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var recentRoutesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent routes")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("Clear")
                    .font(.caption)
                    .foregroundColor(.primaryGreen)
            }
            
            VStack(spacing: 10) {
                ForEach(recentRoutes.indices, id: \.self) { index in
                    let route = recentRoutes[index]
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.primaryGreen.opacity(0.12))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "tram.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.primaryGreen)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(route.from) → \(route.to)")
                                .font(.subheadline)
                                .foregroundColor(.textPrimary)
                            
                            Text(route.time)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            fromStation = route.from
                            toStation = route.to
                        } label: {
                            Text("Use")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryGreen)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.primaryGreen.opacity(0.08))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(10)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .gray.opacity(0.05), radius: 3, x: 0, y: 2)
                }
            }
        }
    }
    
    private var ticketPreviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sample ticket")
            .font(.headline)
            .foregroundColor(.textPrimary)
            
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.primaryGreen, Color.accentGreen]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 160)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Bangalore Metro")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Text("Digital ticket")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "qrcode")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("From")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(fromStation)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white.opacity(0.9))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("To")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(toStation)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Passengers")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("\(passengerCount) · \(isReturn ? "Return" : "One way")")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("Amount")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(isReturn ? "₹80" : "₹40")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(20)
            }
        }
    }
}

#Preview {
    MetroTicketView()
}
