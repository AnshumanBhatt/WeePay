//
//  AddExpenseView.swift
//  WeePay
//
//  Created by Preview Stub
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var amount = ""
    @State private var title = ""
    @State private var selectedCategory = "Food"
    @State private var selectedType = TransactionType.expense
    @State private var description = ""
    @State private var selectedPaymentMethod = PaymentMethod.cash
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Transaction Type Picker
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Type")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        Picker("Transaction Type", selection: $selectedType) {
                            ForEach(TransactionType.allCases, id: \.self) { type in
                                Text(type.displayName).tag(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Amount Input
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Amount")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        HStack {
                            Text("₹")
                                .font(.title2)
                                .foregroundColor(.textSecondary)
                            
                            TextField("0.00", text: $amount)
                                .font(.title2)
                                .keyboardType(.decimalPad)
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    
                    // Title Input
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Title")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        TextField("Enter title", text: $title)
                            .padding(16)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    
                    // Category Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Category")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                            ForEach(ExpenseCategoryModel.defaultCategories.prefix(9), id: \.id) { category in
                                CategoryChip(
                                    category: category,
                                    isSelected: selectedCategory == category.name,
                                    action: { selectedCategory = category.name }
                                )
                            }
                        }
                    }
                    
                    // Description Input
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description (Optional)")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        TextField("Enter description", text: $description)
                            .padding(16)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    
                    // Payment Method
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Payment Method")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        HStack(spacing: 12) {
                            ForEach(PaymentMethod.allCases.prefix(3), id: \.self) { method in
                                PaymentMethodChip(
                                    method: method,
                                    isSelected: selectedPaymentMethod == method,
                                    action: { selectedPaymentMethod = method }
                                )
                            }
                        }
                    }
                    
                    // Save Button
                    Button(action: {
                        // Save logic would go here
                        dismiss()
                    }) {
                        Text("Add Transaction")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(selectedType == .expense ? Color.red : Color.primaryGreen)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .primaryGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(amount.isEmpty || title.isEmpty)
                }
                .padding(.horizontal, 20)
            }
            .background(Color.lightGreen.ignoresSafeArea())
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CategoryChip: View {
    let category: ExpenseCategoryModel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : category.color)
                
                Text(category.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .textPrimary)
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(isSelected ? category.color : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct PaymentMethodChip: View {
    let method: PaymentMethod
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: method.icon)
                    .font(.subheadline)
                
                Text(method.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : .textPrimary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.primaryGreen : Color.white)
            .clipShape(Capsule())
            .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

#Preview {
    AddExpenseView()
}
