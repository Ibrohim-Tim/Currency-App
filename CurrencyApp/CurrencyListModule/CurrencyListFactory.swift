//
//  CurrencyListFactory.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 26.11.2024.
//

import UIKit

final class CurrencyListFactory {
    func create() -> UIViewController {
        let factory = CurrencySelectionFactory()
        let router = CurrencyListRouter(factory: factory)
        let userSettings = UserSettings()
        let symbolsRepository = SymbolsRepository()
        let ratesRepository = RatesRepository()
        
        let dataManager = CurrencyDataManager(
            symbolsRepository: symbolsRepository,
            ratesRepository: ratesRepository,
            userSettings: userSettings
        )
        
        let presenter = CurrencyListPresenter(
            router: router,
            userSettings: userSettings,
            dataManager: dataManager
        )
        
        let vc = CurrencyListViewController(presenter: presenter)
        presenter.view = vc
        router.setRootViewController(root: vc)
        
        return vc
    }
}
