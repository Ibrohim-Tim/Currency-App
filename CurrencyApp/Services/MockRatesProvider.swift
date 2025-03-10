//
//  MockRatesProvider.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 24.12.2024.
//

import Foundation

final class MockRatesProvider {
    
    private let mockRates: [String: Double] = [
        "USD": 1.0,
        "EUR": 0.95,
        "GBP": 0.85,
        "JPY": 110.0,
        "AUD": 1.45,
        "AMD": 480.0,
        "CAD": 1.3,
        "CHF": 0.92
    ]
    
    private let mockDescriptions: [String: String] = [
        "USD": "United States Dollar",
        "EUR": "Euro",
        "GBP": "British Pound Sterling",
        "JPY": "Japanese Yen",
        "AUD": "Australian Dollar",
        "AMD": "Armenian Dram",
        "CAD": "Canadian Dollar",
        "CHF": "Swiss Franc"
    ]
    
    func getMockData(for symbols: [String]) -> (rates: [String: Double], descriptions: [String: String]) {
        let filteredRates = symbols.isEmpty
        ? mockRates
        : symbols.reduce(into: [String: Double]()) { result, symbol in
            result[symbol] = mockRates[symbol] ?? 0.0
        }
        
        let filteredDescriptions = symbols.isEmpty
        ? mockDescriptions
        : symbols.reduce(into: [String: String]()) { result, symbol in
            result[symbol] = mockDescriptions[symbol] ?? "Unknown currency"
        }
        
        return (rates: filteredRates, descriptions: filteredDescriptions)
    }
}
