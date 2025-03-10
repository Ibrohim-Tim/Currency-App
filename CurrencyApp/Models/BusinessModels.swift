//
//  BusinessModels.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 25.10.2024.
//

import Foundation

struct SymbolsModel {
    let symbols: [String: String]
}

extension SymbolsModel {
    init?(response: SymbolsResponse) {
        guard response.success else { return nil }
        
        self.symbols = response.symbols
    }
}

struct LatestModel {
    let base: String
    let date: Date
    let rates: [String: Double]
}

extension LatestModel {
    init(response: LatestResponse) throws {
        guard response.success else { throw ApiClientError.invalidResponse }
        
        self.base = response.base
        
        guard let date = DateFormatter.yyyyMMdd.date(from: response.date) else { throw ApiClientError.invalidDate }
        
        self.date = date
        self.rates = response.rates
    }
}
