//
//  RatesRepository.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 09.11.2024.
//

import Foundation

protocol RatesRepositoryProtocol {
    func fetchRates(base: String, symbols: [String]) async -> Result<LatestModel, ApiClientError>
}

actor CacheStorage {
    private var cache: [String: (Date, LatestModel)] = [:]
    private let cacheLifetime: TimeInterval

    init(cacheLifetime: TimeInterval) {
        self.cacheLifetime = cacheLifetime
    }

    func get(key: String) -> LatestModel? {
        guard let (timestamp, cachedData) = cache[key],
              Date().timeIntervalSince(timestamp) < cacheLifetime else {
            return nil
        }
        return cachedData
    }

    func set(key: String, value: LatestModel) {
        cache[key] = (Date(), value)
    }
}

final class RatesRepository: RatesRepositoryProtocol {

    // MARK: - Private objects
    
    private let networkClient: NetworkClientProtocol
    private let apiKeyProvider: ApiKeyProviderProtocol
    private let cache: CacheStorage
    private var lastRequestTime: Date?
    private let requestInterval: TimeInterval = 30
    
    // MARK: - Init
    
    init(
        networkClient: NetworkClientProtocol = NetworkClient(),
        apiKeyProvider: ApiKeyProviderProtocol = ApiKeyProvider(),
        cacheLifetime: TimeInterval = 3600
    ) {
        self.networkClient = networkClient
        self.apiKeyProvider = apiKeyProvider
        self.cache = CacheStorage(cacheLifetime: cacheLifetime)
    }
    
    // MARK: - Fetch data
    
    func fetchRates(base: String, symbols: [String]) async -> Result<LatestModel, ApiClientError> {
        let cacheKey = "\(base)-\(symbols.sorted().joined(separator: ","))"
        guard !base.isEmpty, !cacheKey.isEmpty else {
            return .failure(.invalidRequest)
        }
        
        if let cachedData = await cache.get(key: cacheKey) {
            return .success(cachedData)
        }
        
        let url = URLBuilder()
            .setPath("/exchangerates_data/latest")
            .setQueryItems([
                "base": base,
                "symbols": symbols.joined(separator: ",")
            ])
            .build()
        
        guard let url = url else {
            return .failure(.invalidResponse)
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        apiKeyProvider.addApiKey(to: &request)
        
        let fetchResult: Result<LatestResponse, ApiClientError> = await networkClient.fetch(request: request)
        
        switch fetchResult {
        case .success(let response):
            do {
                let model = try LatestModel(response: response)
                guard !cacheKey.isEmpty else {
                    return .failure(.invalidRequest)
                }
                
                guard !model.rates.isEmpty else {
                    return .failure(.invalidResponse)
                }
                
                await cache.set(key: cacheKey, value: model)
                return .success(model)
            } catch let error as ApiClientError {
                return .failure(error)
            } catch {
                return .failure(.deserialize(error))
            }
        case .failure(let error):
            return .failure(.network(error))
        }
    }
}
