//
//  MiningView.swift
//  Blockchain_demo
//
//  Created by 徐柏勳 on 5/11/25.
//

import SwiftUI

struct MiningView: View {
    @EnvironmentObject var viewModel: BlockchainViewModel
    @State private var showMiningSuccessAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                miningHeaderView

                miningDescriptionView
                
                miningButton
                
                if viewModel.isLoading {
                    loadingView
                }
                
                if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .navigationTitle("Mining")
            .alert(isPresented: $showMiningSuccessAlert) {
                miningSuccessAlert
            }
        }
    }

    @MainActor
    @ViewBuilder
    private var miningHeaderView: some View {
        Image(systemName: "hammer.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .foregroundColor(.blue)
            .padding(.top, 25)

        Text("Let's Mine!")
            .font(.headline)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }
    
    @MainActor
    @ViewBuilder
    private var miningDescriptionView: some View {
        Text("""
             For every Block mined,
             the miner will receive 1 Coin as a reward
             """)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding(.top, 10)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }
    
    @MainActor
    @ViewBuilder
    private var miningButton: some View {
        Button(action: {
            mineBlock()
        }) {
            HStack {
                Image(systemName: "hammer")
                Text("Start mining")
            }
            .frame(minWidth: 200)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding(.top, 30)
        .disabled(viewModel.isLoading)
        .frame(maxWidth: .infinity)
    }
    
    @MainActor
    @ViewBuilder
    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
                .padding()
            Text("Computing...")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
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
    private var miningSuccessAlert: Alert {
        Alert(
            title: Text("Mining Success"),
            message: Text("You have successfully mined a new block and received a reward"),
            dismissButton: .default(Text("Awesome"))
        )
    }
    
    private func mineBlock() {
        viewModel.mineBlock()
        
        // 如果挖礦成功，顯示成功訊息
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if viewModel.errorMessage == nil {
                showMiningSuccessAlert = true
            }
        }
    }
}

#Preview {
    MiningView()
        .environmentObject(BlockchainViewModel())
}

