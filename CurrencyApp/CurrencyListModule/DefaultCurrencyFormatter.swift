//
//  DefaultCurrencyFormatter.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 13.01.2025.
//

import Foundation

protocol CurrencyFormatter {
    func formatExchangeRate(code: String, rate: Double, baseCurrency: String) -> String
}

final class DefaultCurrencyFormatter: CurrencyFormatter {
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 6
        formatter.locale = Locale.current
        return formatter
    }()
    
    func formatExchangeRate(code: String, rate: Double, baseCurrency: String) -> String {
        guard let formattedRate = numberFormatter.string(from: NSNumber(value: rate)) else {
            return "Error formatting rate"
        }
        
        return "1 \(code) = \(formattedRate) \(baseCurrency)"
    }
}
