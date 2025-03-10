//
//  CurrencyDataManager.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 27.01.2025.
//

import Foundation

protocol CurrencyDataManagerProtocol {
    func fetchAllData() async throws -> (symbols: [String: String], rates: [String: Double])
    func fetchSymbols() async throws -> [String: String]
    func fetchRates() async throws -> [String: Double]
    func resetCache()
    
    var symbolsRepository: SymbolsRepositoryProtocol { get }
}

final class CurrencyDataManager: CurrencyDataManagerProtocol {
    
    // MARK: - Properties
    
    let symbolsRepository: SymbolsRepositoryProtocol
    private let ratesRepository: RatesRepositoryProtocol
    private let userSettings: UserSettingsProtocol
    
    private var cachedRates: [String: Double] = [:]
    private var cachedSymbols: [String: String] = [:]
    
    // MARK: - Initialization
    
    init(
        symbolsRepository: SymbolsRepositoryProtocol,
        ratesRepository: RatesRepositoryProtocol,
        userSettings: UserSettingsProtocol
    ) {
        self.symbolsRepository = symbolsRepository
        self.ratesRepository = ratesRepository
        self.userSettings = userSettings
    }
    
    // MARK: - Public Methods
    
    func fetchAllData() async throws -> (symbols: [String: String], rates: [String: Double]) {
        async let symbols = fetchSymbols()
        async let rates = fetchRates()
        return (try await symbols, try await rates)
    }
    
    func fetchSymbols() async throws -> [String: String] {
        if cachedSymbols.isEmpty {
            try await updateCachedSymbols()
        }
        return cachedSymbols
    }
    
    func fetchRates() async throws -> [String: Double] {
        if cachedRates.isEmpty {
            try await updateCachedRates()
        }
        return cachedRates
    }
    
    func resetCache() {
        cachedRates.removeAll()
        cachedSymbols.removeAll()
    }
    
    // MARK: - Private Methods
    
    private func updateCachedSymbols() async throws {
        let result = await symbolsRepository.fetchSymbols()
        switch result {
        case .success(let symbolsModel):
            cachedSymbols = symbolsModel.symbols
        case .failure:
            throw CurrencyDataManagerError.failedToFetchSymbols
        }
    }
    
    private func updateCachedRates() async throws {
        let result = await ratesRepository.fetchRates(
            base: userSettings.currentCurrencyId,
            symbols: userSettings.currenciesIds
        )
        switch result {
        case .success(let latestModel):
            cachedRates = latestModel.rates
        case .failure:
            throw CurrencyDataManagerError.failedToFetchRates
        }
    }
    
    // MARK: - Error Handling
    
    enum CurrencyDataManagerError: Error {
        case failedToFetchSymbols
        case failedToFetchRates
    }
}
