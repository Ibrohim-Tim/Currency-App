//
//  DateFormatter+Extension.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 04.11.2024.
//

import Foundation

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone.ReferenceType.default
        return df
    }()
    
    static func getCurrentDateString() -> String {
        DateFormatter.localizedString(
            from: Date(),
            dateStyle: .medium,
            timeStyle: .short
        )
    }
}
