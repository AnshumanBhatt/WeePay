//
//  AddExpenseView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 26/08/25.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var expenseViewModel = ExpenseTrackingViewModel()
    
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var selectedTransactionType: TransactionType = .expense
    @State private var selectedCategory: ExpenseCategoryModel = ExpenseCategoryModel.defaultCategories[0]
    @State private var selectedPaymentMethod: PaymentMethod = .cash
    @State private var description: String = ""
    @State private var recipientName: String = ""
    @State private var recipientPhone: String = ""
    @State private var showingCategoryPicker = false
    @State private var showingPaymentMethodPicker = false
    
    var isAddButtonDisabled: Bool {
        title.isEmpty || amount.isEmpty || Double(amount) == nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lightGreen.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Card
                        headerCard
                        
                        // Amount Input Card
                        amountInputCard
                        
                        // Transaction Details Card
                        detailsCard
                        
                        // Category Selection Card
                        categorySelectionCard
                        
                        // Payment Method Card (for expenses and payments)
                        if selectedTransactionType != .income {
                            paymentMethodCard
                        }
                        
                        // Recipient Details (for payments)
                        if selectedTransactionType == .payment {
                            recipientDetailsCard
                        }
                        
                        // Description Card
                        descriptionCard
                        
                        // Add Button
                        addButton
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryGreen)
                }
            }
            .alert("Error", isPresented: $expenseViewModel.showError) {
                Button("OK") {}
            } message: {
                Text(expenseViewModel.errorMessage)
            }
        }
    }
    
    private var headerCard: some View {
        VStack(spacing: 16) {
            Image(systemName: selectedTransactionType == .expense ? "minus.circle.fill" : 
                  selectedTransactionType == .income ? "plus.circle.fill" : "arrow.right.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(selectedTransactionType == .expense ? .red : 
                               selectedTransactionType == .income ? .primaryGreen : .blue)
            
            Text(selectedTransactionType.displayName)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            // Transaction Type Selector
            Picker("Transaction Type", selection: $selectedTransactionType) {
                ForEach(TransactionType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedTransactionType) { _, newType in
                // Reset category when transaction type changes
                if newType == .income {
                    selectedCategory = ExpenseCategoryModel.getCategoryByName("Income")
                } else {
                    selectedCategory = ExpenseCategoryModel.defaultCategories.first { $0.name != "Income" } ?? ExpenseCategoryModel.defaultCategories[0]
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
    }
    
    private var amountInputCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Amount")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            HStack {
                Text("₹")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                TextField("0.00", text: $amount)
                    .font(.system(size: 24, weight: .bold))
                    .keyboardType(.decimalPad)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(16)
            .background(Color.lightGreen.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
    }
    
    private var detailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Details")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            TextField("Enter title (e.g., Lunch at restaurant)", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
    }
    
    private var categorySelectionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Button(action: { showingCategoryPicker = true }) {
                HStack {
                    Image(systemName: selectedCategory.icon)
                        .foregroundColor(selectedCategory.color)
                        .frame(width: 24, height: 24)
                    
                    Text(selectedCategory.name)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.textSecondary)
                }
                .padding(16)
                .background(Color.lightGreen.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
        .sheet(isPresented: $showingCategoryPicker) {
            CategoryPickerView(selectedCategory: $selectedCategory, transactionType: selectedTransactionType)
        }
    }
    
    private var paymentMethodCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Payment Method")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Button(action: { showingPaymentMethodPicker = true }) {
                HStack {
                    Image(systemName: selectedPaymentMethod.icon)
                        .foregroundColor(.primaryGreen)
                        .frame(width: 24, height: 24)
                    
                    Text(selectedPaymentMethod.displayName)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.textSecondary)
                }
                .padding(16)
                .background(Color.lightGreen.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
        .sheet(isPresented: $showingPaymentMethodPicker) {
            PaymentMethodPickerView(selectedPaymentMethod: $selectedPaymentMethod)
        }
    }
    
    private var recipientDetailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recipient Details")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                TextField("Recipient Name", text: $recipientName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Phone Number", text: $recipientPhone)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
    }
    
    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Description (Optional)")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            TextField("Add any notes...", text: $description, axis: .vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .lineLimit(3...6)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 3)
    }
    
    private var addButton: some View {
        Button(action: addTransaction) {
            HStack {
                if expenseViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
                
                Text("Add \(selectedTransactionType.displayName)")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(isAddButtonDisabled ? Color.gray : Color.primaryGreen)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: isAddButtonDisabled ? .clear : .primaryGreen.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .disabled(isAddButtonDisabled || expenseViewModel.isLoading)
        .padding(.horizontal, 20)
    }
    
    private func addTransaction() {
        guard let amountValue = Double(amount) else { return }
        
        expenseViewModel.addTransaction(
            title: title,
            amount: amountValue,
            type: selectedTransactionType,
            category: selectedCategory.name,
            description: description,
            paymentMethod: selectedTransactionType == .income ? nil : selectedPaymentMethod,
            recipientName: recipientName.isEmpty ? nil : recipientName,
            recipientPhone: recipientPhone.isEmpty ? nil : recipientPhone
        )
        
        // Close the view after successful addition
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dismiss()
        }
    }
}

#Preview {
    AddExpenseView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
