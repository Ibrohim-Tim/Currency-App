//
//  CurrencyModelBuilder.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 27.01.2025.
//

import Foundation

struct CurrencyModelBuilder {
    
    // MARK: - Dependencies
    
    private let currencyFormatter: CurrencyFormatter
    private let userSettings: UserSettingsProtocol
    
    // MARK: - Initialization
    
    init(currencyFormatter: CurrencyFormatter, userSettings: UserSettingsProtocol) {
        self.currencyFormatter = currencyFormatter
        self.userSettings = userSettings
    }
    
    // MARK: - Public Methods
    
    func buildCurrencyListModel(
        from symbols: [String: String],
        rates: [String: Double]
    ) -> CurrencyListView.Model {
        let items = rates.map { code, rate in
            buildCellModel(code: code, rate: rate, symbols: symbols)
        }
        return CurrencyListView.Model(items: items.sorted { $0.code < $1.code })
    }
    
    func buildCellModel(
        code: String,
        rate: Double,
        symbols: [String: String]
    ) -> CurrencyListTableViewCell.Model {
        let description = symbols[code] ?? "Unknown currency"
        let calculatedRate = calculateRate(rate)
        let exchangeRate = formatExchangeRate(code: code, rate: rate)
        
        return CurrencyListTableViewCell.Model(
            code: code,
            description: description,
            flag: getFlagImageName(for: code),
            rate: calculatedRate,
            exchangeRate: exchangeRate
        )
    }
    
    func getFlagImageName(for currencyCode: String) -> String {
        currencyCode
    }
    
    // MARK: - Private Methods
   
    private func calculateRate(_ rate: Double) -> Double {
        rate * userSettings.currentAmount
    }
    
    private func formatExchangeRate(code: String, rate: Double) -> String {
        currencyFormatter.formatExchangeRate(
            code: code,
            rate: rate,
            baseCurrency: userSettings.currentCurrencyId
        )
    }
}
