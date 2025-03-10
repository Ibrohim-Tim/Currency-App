//
//  ApiClientError.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 08.11.2024.
//

import Foundation

enum ApiClientError: Error {
    case network(Error)
    case invalidResponse
    case invalidRequest
    case service(Int)
    case empty
    case deserialize(Error)
    case invalidDate
    case tooManyRequests
}
