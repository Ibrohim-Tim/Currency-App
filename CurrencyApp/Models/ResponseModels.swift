//
//  Response.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 15.10.2024.
//

import Foundation

struct SymbolsResponse: Decodable {
    let success: Bool
    let symbols: [String: String]
}

struct LatestResponse: Decodable {
    let base: String
    let date: String
    let rates: [String: Double]
    let success: Bool
    let timestamp: Int
}
