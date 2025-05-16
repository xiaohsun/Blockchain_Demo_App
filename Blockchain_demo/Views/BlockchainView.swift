//
//  BlockchainView.swift
//  Blockchain_demo
//
//  Created by 徐柏勳 on 5/11/25.
//

import SwiftUI

struct BlockchainView: View {
    @EnvironmentObject var viewModel: BlockchainViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    loadingView
                }
                
                if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                }
                
                blocksList
            }
            .navigationTitle("Blockchain")
            .toolbar {
                toolbarItems
            }
        }
    }
    
    @MainActor
    @ViewBuilder
    private var loadingView: some View {
        ProgressView()
            .scaleEffect(1.5)
            .padding()
            .frame(maxWidth: .infinity)
    }
    
    @MainActor
    @ViewBuilder
    private func errorView(message: String) -> some View {
        Text(message)
            .foregroundColor(.red)
            .padding()
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }
    
    @MainActor
    @ViewBuilder
    private var blocksList: some View {
        List {
            ForEach(viewModel.blocks.indices, id: \.self) { index in
                let block = viewModel.blocks[index]
                BlockView(block: block, index: index)
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            viewModel.loadChain()
        }
    }
    
    @MainActor
    @ViewBuilder
    private var toolbarItems: some View {
        Button(action: {
            viewModel.loadChain()
        }) {
            Label("Refresh", systemImage: "arrow.clockwise")
        }
    }
}

struct BlockView: View {
    let block: Block
    let index: Int
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            blockHeader
            
            if isExpanded {
                blockContent
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
        )
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    @MainActor
    @ViewBuilder
    private var blockHeader: some View {
        HStack {
            Text("Block #\(block.index)")
                .font(.headline)
            Spacer()
            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
    
    @MainActor
    @ViewBuilder
    private var blockContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()
            
            blockDetails
            
            if !block.transactions.isEmpty {
                transactionsList
            }
        }
    }
    
    @MainActor
    @ViewBuilder
    private var blockDetails: some View {
        Text("Created: \(formattedDate(from: block.timestamp))")
            .font(.subheadline)
        
        Text("Transactions: \(block.transactions.count)")
            .font(.subheadline)
        
        Text("Proof of Work: \(block.proof)")
            .font(.subheadline)
        
        Text("Previous Hash:")
            .font(.subheadline)
        Text(block.previousHash)
            .font(.caption)
            .foregroundColor(.secondary)
            .lineLimit(1)
            .truncationMode(.middle)
    }
    
    @MainActor
    @ViewBuilder
    private var transactionsList: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Transaction List:")
                .font(.subheadline)
                .padding(.top, 4)
            
            ForEach(block.transactions.indices, id: \.self) { i in
                let transaction = block.transactions[i]
                TransactionRow(transaction: transaction, index: i)
                    .padding(.vertical, 2)
            }
        }
        .padding(.top, 4)
    }
    
    private func formattedDate(from timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            transactionHeader
            
            transactionDetails
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.tertiarySystemBackground))
        )
    }
    
    @MainActor
    @ViewBuilder
    private var transactionHeader: some View {
        Text("Transaction #\(index + 1)")
            .font(.caption)
            .bold()
    }
    
    @MainActor
    @ViewBuilder
    private var transactionDetails: some View {
        HStack {
            Text("From:")
                .font(.caption)
            Text(transaction.sender)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .truncationMode(.middle)
        }
        
        HStack {
            Text("To:")
                .font(.caption)
            Text(transaction.recipient)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .truncationMode(.middle)
        }
        
        Text("Amount: \(transaction.amount)")
            .font(.caption)
    }
}

#Preview {
    BlockchainView()
        .environmentObject(BlockchainViewModel())
}
