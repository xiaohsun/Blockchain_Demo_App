//
//  TransactionsView.swift
//  Blockchain_demo
//
//  Created by 徐柏勳 on 5/11/25.
//

import SwiftUI

struct TransactionsView: View {
    @EnvironmentObject var viewModel: BlockchainViewModel
    
    @State private var sender = ""
    @State private var recipient = ""
    @State private var amountString = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                newTransactionSection
                
                recentTransactionsSection
            }
            .navigationTitle("Transactions")
            .alert(isPresented: $showAlert) {
                alertView
            }
            .overlay(loadingOverlay)
        }
    }
    
    @MainActor
    @ViewBuilder
    private var newTransactionSection: some View {
        Section(header: Text("Create New Transaction")) {
            TextField("Sender Address", text: $sender)
                .disableAutocorrection(true)
            
            TextField("Recipient Address", text: $recipient)
                .disableAutocorrection(true)
            
            TextField("Amount", text: $amountString)
            
            Button(action: {
                createTransaction()
            }) {
                Text("Send Transaction")
                    .frame(maxWidth: .infinity)
            }
            .disabled(isFormInvalid)
            .buttonStyle(.borderedProminent)
        }
    }
    
    @MainActor
    @ViewBuilder
    private var recentTransactionsSection: some View {
        Section(header: Text("Recent Transactions")) {
            if viewModel.blocks.isEmpty {
                Text("No transaction records")
                    .foregroundColor(.secondary)
            } else {
                // Display transactions from the latest block
                let recentTransactions = getRecentTransactions()
                if recentTransactions.isEmpty {
                    Text("No transaction records")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(recentTransactions.indices, id: \.self) { index in
                        transactionItemView(transaction: recentTransactions[index])
                    }
                }
            }
        }
    }
    
    @MainActor
    @ViewBuilder
    private func transactionItemView(transaction: Transaction) -> some View {
        VStack(alignment: .leading) {
            Text("From: \(transaction.sender)")
                .font(.subheadline)
            Text("To: \(transaction.recipient)")
                .font(.subheadline)
            Text("Amount: \(transaction.amount)")
                .font(.headline)
        }
        .padding(.vertical, 4)
    }
    
    @MainActor
    @ViewBuilder
    private var loadingOverlay: some View {
        Group {
            if viewModel.isLoading {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
    }
    
    @MainActor
    private var alertView: Alert {
        Alert(
            title: Text(alertTitle),
            message: Text(alertMessage),
            dismissButton: .default(Text("OK"))
        )
    }
    
    private var isFormInvalid: Bool {
        sender.isEmpty || recipient.isEmpty || amountString.isEmpty || Int(amountString) == nil
    }
    
    private func createTransaction() {
        guard let amount = Int(amountString) else {
            alertTitle = "Error"
            alertMessage = "Please enter a valid amount"
            showAlert = true
            return
        }
        
        viewModel.createTransaction(sender: sender, recipient: recipient, amount: amount)
        
        // Clear form
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sender = ""
            recipient = ""
            amountString = ""
            
            // Show success message
            if viewModel.errorMessage != nil {
                alertTitle = "Notification"
                alertMessage = viewModel.errorMessage ?? "Transaction sent"
                showAlert = true
            }
        }
    }
    
    private func getRecentTransactions() -> [Transaction] {
        // Collect transactions from all blocks and sort by latest
        let allTransactions = viewModel.blocks.flatMap { $0.transactions }
        return Array(allTransactions.prefix(10)) // Show the 10 most recent transactions
    }
}

#Preview {
    TransactionsView()
        .environmentObject(BlockchainViewModel())
}
