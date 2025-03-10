//
//  DataDecoder.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 08.11.2024.
//

import Foundation

protocol DataDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

final class JSONDataDecoder: DataDecoder {
    
    private let decoder = JSONDecoder()
    
    func decode<T: Decodable>(_ data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}
