//
//  ApiKeyProvider.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 08.11.2024.
//

import Foundation

protocol ApiKeyProviderProtocol {
    func addApiKey(to request: inout URLRequest)
}

final class ApiKeyProvider: ApiKeyProviderProtocol {
    
    private let apiKey = "vX3tMOuF6qynT9N1sMM7RSU5ID51dDeA"
    
    func addApiKey(to request: inout URLRequest) {
        request.addValue(apiKey, forHTTPHeaderField: "apikey")
    }
}
