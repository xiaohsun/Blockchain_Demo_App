//
//  Transaction.swift
//  Blockchain_demo
//
//  Created by 徐柏勳 on 5/11/25.
//

import Foundation

struct Transaction: Codable {
    let sender: String
    let recipient: String
    let amount: Int
} 
