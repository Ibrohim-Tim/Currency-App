//
//  UserSettings.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 18.11.2024.
//

import Foundation

protocol UserSettingsProtocol {
    var currentCurrencyId: String { get set }
    var currenciesIds: [String] { get set }
    var currentAmount: Double { get set }
}

final class UserSettings: UserSettingsProtocol {
    
    private let userDefaults: UserDefaults
        
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var currentCurrencyId: String {
        get {
            userDefaults.string(forKey: Constants.currentCurrencyId) ?? Constants.startUserCurrency
        }
        set {
            userDefaults.setValue(newValue, forKey: Constants.currentCurrencyId)
        }
    }
    
    var currenciesIds: [String] {
        get {
            userDefaults.stringArray(forKey: Constants.currenciesIds) ?? Constants.startListCurrency
        }
        set {
            userDefaults.setValue(newValue, forKey: Constants.currenciesIds)
        }
    }
    
    var currentAmount: Double {
        get {
            userDefaults.double(forKey: Constants.currentAmountKey)
        }
        set {
            userDefaults.setValue(newValue, forKey: Constants.currentAmountKey)
        }
    }
}

extension UserSettings {
    enum Constants {
        static let currentCurrencyId = "currentCurrencyId"
        static let currenciesIds = "currenciesIds"
        static let startUserCurrency = "RUB"
        static let startListCurrency = ["USD", "EUR", "GBP"]
        static let currentAmountKey = "currentAmountKey"
    }
}
