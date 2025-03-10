//
//  URLBuilder.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 12.11.2024.
//

import Foundation

final class URLBuilder {
    
    private var components: URLComponents
    
    init(scheme: String = "https", host: String = "api.apilayer.com") {
        self.components = URLComponents()
        self.components.scheme = scheme
        self.components.host = host
    }
    
    func setPath(_ path: String) -> URLBuilder {
        components.path = path
        return self
    }
    
    func setQueryItems(_ parameters: [String: String]) -> URLBuilder {
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        return self
    }
    
    func build() -> URL? {
        return components.url
    }
}
