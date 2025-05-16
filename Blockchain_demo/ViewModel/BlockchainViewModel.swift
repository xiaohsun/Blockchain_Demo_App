//
//  BlockchainViewModel.swift
//  Blockchain_demo
//
//  Created by 徐柏勳 on 5/11/25.
//

import Foundation
import Combine

class BlockchainViewModel: ObservableObject {
    // Base API URL, default to local server during development
    private let baseURL = "http://localhost:8080"
    
    // Blockchain data
    @Published var blocks: [Block] = []
    @Published var pendingTransactions: [Transaction] = []
    @Published var nodes: [String] = []
    @Published var errorMessage: String?
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadChain()
    }
    
    // MARK: - API Calls
    
    /// Load the complete blockchain
    func loadChain() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/chain") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ChainResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Failed to load blockchain: \(error.localizedDescription)"
                }
            } receiveValue: { response in
                self.blocks = response.chain
            }
            .store(in: &cancellables)
    }
    
    /// Mine a new block
    func mineBlock() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/mine") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MineResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Mining failed: \(error.localizedDescription)"
                }
            } receiveValue: { response in
                // Reload chain after successful mining
                self.loadChain()
            }
            .store(in: &cancellables)
    }
    
    /// Create a new transaction
    func createTransaction(sender: String, recipient: String, amount: Int) {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/transactions/new") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        // Create request content
        let transaction = TransactionRequest(sender: sender, recipient: recipient, amount: amount)
        
        // Prepare request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(transaction)
        } catch {
            errorMessage = "Failed to encode transaction data: \(error.localizedDescription)"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: TransactionResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Failed to create transaction: \(error.localizedDescription)"
                }
            } receiveValue: { response in
                // Show success message
                self.errorMessage = response.message
            }
            .store(in: &cancellables)
    }
    
    /// Register a new node
    func registerNode(address: String) {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/nodes/register") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        // Create request content
        let nodesRequest = NodesRequest(nodes: [address])
        
        // Prepare request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(nodesRequest)
        } catch {
            errorMessage = "Failed to encode node data: \(error.localizedDescription)"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: NodesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Failed to register node: \(error.localizedDescription)"
                }
            } receiveValue: { response in
                self.nodes = response.totalNodes
            }
            .store(in: &cancellables)
    }
    
    /// Resolve conflicts between nodes
    func resolveConflicts() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/nodes/resolve") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ReplacedChainResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Failed to resolve conflicts: \(error.localizedDescription)"
                }
            } receiveValue: { response in
                self.blocks = response.newChain
                self.errorMessage = response.message
            }
            .store(in: &cancellables)
    }
}
