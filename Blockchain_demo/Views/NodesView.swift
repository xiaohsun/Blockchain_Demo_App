//
//  NodesView.swift
//  Blockchain_demo
//
//  Created by 徐柏勳 on 5/11/25.
//

import SwiftUI

struct NodesView: View {
    @EnvironmentObject var viewModel: BlockchainViewModel
    @State private var nodeAddress = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                addNodeSection
                
                knownNodesSection
                
                consensusSection
            }
            .navigationTitle("Node Management")
            .overlay(loadingOverlay)
            .alert(isPresented: $showAlert) {
                alertView
            }
        }
    }
    
    @MainActor
    @ViewBuilder
    private var addNodeSection: some View {
        Section(header: Text("Add New Node")) {
            TextField("Node address (e.g. 192.168.1.1:8080)", text: $nodeAddress)
                .disableAutocorrection(true)
            
            Button(action: {
                registerNode()
            }) {
                Text("Register Node")
                    .frame(maxWidth: .infinity)
            }
            .disabled(nodeAddress.isEmpty || viewModel.isLoading)
            .buttonStyle(.borderedProminent)
        }
    }
    
    @MainActor
    @ViewBuilder
    private var knownNodesSection: some View {
        Section(header: Text("Known Nodes")) {
            if viewModel.nodes.isEmpty {
                Text("No registered nodes")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.nodes, id: \.self) { node in
                    nodeRow(node: node)
                }
            }
        }
    }
    
    @MainActor
    @ViewBuilder
    private func nodeRow(node: String) -> some View {
        HStack {
            Text(node)
            Spacer()
            Image(systemName: "circle.fill")
                .foregroundColor(.green)
                .font(.system(size: 10))
        }
    }
    
    @MainActor
    @ViewBuilder
    private var consensusSection: some View {
        Section {
            Button(action: {
                resolveConflicts()
            }) {
                HStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text("Resolve Conflicts")
                }
                .frame(maxWidth: .infinity)
            }
            .disabled(viewModel.nodes.isEmpty || viewModel.isLoading)
            .foregroundColor(.white)
            .buttonStyle(.borderedProminent)
            .tint(.orange)
        } header: {
            Text("Blockchain Consensus")
        } footer: {
            Text("When connected to multiple nodes, this feature resolves conflicts in the blockchain, ensuring you have the longest valid chain.")
        }
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
    
    private func registerNode() {
        viewModel.registerNode(address: nodeAddress)
        
        // Clear the form
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            nodeAddress = ""
            
            // Show success message
            if let errorMessage = viewModel.errorMessage {
                alertTitle = "Error"
                alertMessage = errorMessage
            } else {
                alertTitle = "Success"
                alertMessage = "Node registered successfully"
            }
            showAlert = true
        }
    }
    
    private func resolveConflicts() {
        viewModel.resolveConflicts()
        
        // Show result
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let errorMessage = viewModel.errorMessage {
                alertTitle = "Result"
                alertMessage = errorMessage
                showAlert = true
            }
        }
    }
}

#Preview {
    NodesView()
        .environmentObject(BlockchainViewModel())
}
