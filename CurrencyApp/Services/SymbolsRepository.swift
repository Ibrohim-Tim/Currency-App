//
//  SymbolsRepository.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 09.11.2024.
//

import Foundation

protocol SymbolsRepositoryProtocol {
    func fetchSymbols() async -> Result<SymbolsModel, ApiClientError>
}

final class SymbolsRepository: SymbolsRepositoryProtocol {
    
    // MARK: - Private objects
    
    private let networkClient: NetworkClientProtocol
    private let apiKeyProvider: ApiKeyProviderProtocol
    
    private var cachedSymbols: SymbolsModel?
    private var cacheTimestamp: Date?
    private let cacheLifetime: TimeInterval = 3600
    
    // MARK: - Init
    
    init(networkClient: NetworkClientProtocol = NetworkClient(),
         apiKeyProvider: ApiKeyProviderProtocol = ApiKeyProvider()
    ) {
        self.networkClient = networkClient
        self.apiKeyProvider = apiKeyProvider
    }
    
    func resetCached() {
        cachedSymbols = nil
        cacheTimestamp = nil
    }
    
    // MARK: - Fetch data
    
    func fetchSymbols() async -> Result<SymbolsModel, ApiClientError> {
        if let cachedSymbols = cachedSymbols, let cacheTimestamp = cacheTimestamp {
            let now = Date()
            
            if now.timeIntervalSince(cacheTimestamp) < cacheLifetime {
                return .success(cachedSymbols)
            } else {
                resetCached()
            }
        }
        
        let url = URLBuilder()
            .setPath("/exchangerates_data/symbols")
            .build()
        
        guard let url = url else {
            return .failure(.invalidResponse)
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        apiKeyProvider.addApiKey(to: &request)
        
        let result: Result<SymbolsResponse, ApiClientError> = await networkClient.fetch(request: request)
        
        switch result {
        case .success(let response):
            let model = SymbolsModel(symbols: response.symbols)
            cachedSymbols = model
            cacheTimestamp = Date()
            return .success(model)
        case .failure(let error):
            return .failure(error)
        }
    }
}
