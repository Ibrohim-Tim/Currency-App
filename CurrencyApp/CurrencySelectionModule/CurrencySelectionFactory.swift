//
//  CurrencySelectionFactory.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 26.11.2024.
//

import UIKit

final class CurrencySelectionFactory {
    
    struct Context {
        let mode: Mode
        let checkedCurrencyIds: Set<CurrencyId>
        let onChanged: (Set<CurrencyId>) -> Void
        let service: SymbolsRepositoryProtocol
        
        enum Mode {
            case single
            case multiple
        }
    }
    
    func make(context: Context) -> UIViewController {
        let presenter = CurrencySelectionPresenter(
            service: context.service,
            mode: context.mode,
            checkedCurrencyIds: context.checkedCurrencyIds,
            onChanged: context.onChanged
        )
        
        let vc = CurrencySelectionViewController(presenter: presenter)
        presenter.view = vc
        return vc
    }
}
