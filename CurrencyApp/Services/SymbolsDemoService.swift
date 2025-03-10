//
//  SymbolsDemoService.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 12.11.2024.
//

import Foundation

final class SymbolsDemoService: SymbolsRepositoryProtocol {
    
    func fetchSymbols() async -> Result<SymbolsModel, ApiClientError> {
        let demoSymbols = SymbolsModel(symbols: [
            "RUB": "Russian Ruble",
            "USD": "United States Dollar",
            "EUR": "Euro",
            "GBP": "British Pound Sterling",
            "JPY": "Japanese Yen"
        ])
        
        return .success(demoSymbols)
    }
}
