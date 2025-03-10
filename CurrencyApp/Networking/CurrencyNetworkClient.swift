//
//  CurrencyNetworkClient.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 08.11.2024.
//

import Foundation

protocol NetworkClientProtocol {
    func fetch<T: Decodable>(request: URLRequest) async -> Result<T, ApiClientError>
}

final class NetworkClient: NetworkClientProtocol {
    
    private let session: URLSession
    private let decoder: DataDecoder
    
    init(session: URLSession = .shared, decoder: DataDecoder = JSONDataDecoder(), timeoutInterval: TimeInterval = 15) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        configuration.timeoutIntervalForResource = timeoutInterval
        
        self.session = URLSession(configuration: configuration)
        self.decoder = decoder
    }
    
    func fetch<T: Decodable>(request: URLRequest) async -> Result<T, ApiClientError> {
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                return .failure(.service(httpResponse.statusCode))
            }
            
            guard !data.isEmpty else {
                return .failure(.empty)
            }
            
            do {
                let result: T = try decoder.decode(data)
                return .success(result)
            } catch {
                return .failure(.deserialize(error))
            }
        } catch {
            return .failure(.network(error))
        }
    }
}
