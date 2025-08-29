//
//  CategoryPickerView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 26/08/25.
//

import SwiftUI

struct CategoryPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCategory: ExpenseCategoryModel
    let transactionType: TransactionType
    
    var availableCategories: [ExpenseCategoryModel] {
        if transactionType == .income {
            return [ExpenseCategoryModel.getCategoryByName("Income")]
        } else {
            return ExpenseCategoryModel.defaultCategories.filter { $0.name != "Income" }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lightGreen.ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                        ForEach(availableCategories, id: \.name) { category in
                            CategoryItem(
                                category: category,
                                isSelected: selectedCategory.name == category.name
                            ) {
                                selectedCategory = category
                                dismiss()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Select Category")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryGreen)
                }
            }
        }
    }
}

struct CategoryItem: View {
    let category: ExpenseCategoryModel
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.system(size: 32))
                    .foregroundColor(category.color)
                    .frame(width: 50, height: 50)
                    .background(category.color.opacity(0.1))
                    .clipShape(Circle())
                
                Text(category.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(isSelected ? category.color.opacity(0.1) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? category.color : Color.clear, lineWidth: 2)
            )
            .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

#Preview {
    CategoryPickerView(
        selectedCategory: .constant(ExpenseCategoryModel.defaultCategories[0]),
        transactionType: .expense
    )
}
