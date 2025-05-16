//
//  ApiResponses.swift
//  Blockchain_demo
//
//  Created by 徐柏勳 on 5/11/25.
//

import Foundation

struct ChainResponse: Codable {
    let chain: [Block]
    let length: Int
}

struct MineResponse: Codable {
    let message: String
    let index: Int
    let transactions: [Transaction]
    let proof: Int
    let previousHash: String
}

struct TransactionResponse: Codable {
    let message: String
}

struct NodesResponse: Codable {
    let message: String
    let totalNodes: [String]
}

struct ReplacedChainResponse: Codable {
    let message: String
    let newChain: [Block]
}

struct AuthoritativeChainResponse: Codable {
    let message: String
    let chain: [Block]
}

struct ErrorResponse: Codable {
    let message: String
}
