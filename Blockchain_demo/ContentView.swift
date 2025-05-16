//
//  ContentView.swift
//  Blockchain_demo
//
//  Created by 徐柏勳 on 5/11/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: BlockchainViewModel
    
    var body: some View {
        TabView {
            BlockchainView()
                .tabItem {
                    Label("區塊鏈", systemImage: "link")
                }
            
            TransactionsView()
                .tabItem {
                    Label("交易", systemImage: "arrow.left.arrow.right")
                }
            
            MiningView()
                .tabItem {
                    Label("挖礦", systemImage: "hammer")
                }
            
            NodesView()
                .tabItem {
                    Label("節點", systemImage: "network")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BlockchainViewModel())
}
