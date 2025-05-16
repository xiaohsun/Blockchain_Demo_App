//
//  Blockchain_demoApp.swift
//  Blockchain_demo
//
//  Created by 徐柏勳 on 5/11/25.
//

import SwiftUI

@main
struct Blockchain_demoApp: App {
    @StateObject private var blockchainViewModel = BlockchainViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(blockchainViewModel)
        }
    }
}
