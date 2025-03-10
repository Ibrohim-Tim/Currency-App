//
//  CurrencyListRouter.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 26.11.2024.
//

import UIKit

protocol CurrencyListRouterProtocol: AnyObject {
    func openCurrencySelection(
        mode: CurrencySelectionFactory.Context.Mode,
        checkedCurrencyIds: Set<CurrencyId>,
        service: SymbolsRepositoryProtocol,
        onChanged: @escaping (Set<CurrencyId>) -> Void
    )
}

final class CurrencyListRouter: CurrencyListRouterProtocol {
    
    private let factory: CurrencySelectionFactory
    private weak var root: UIViewController?
    
    init(factory: CurrencySelectionFactory) {
        self.factory = factory
    }
    
    func setRootViewController(root: UIViewController) {
        self.root = root
    }
    
    func openCurrencySelection(
        mode: CurrencySelectionFactory.Context.Mode,
        checkedCurrencyIds: Set<CurrencyId>,
        service: SymbolsRepositoryProtocol,
        onChanged: @escaping (Set<CurrencyId>) -> Void
    ) {
        Task { [weak self] in
            guard let self = self else { return }
            
            let context = CurrencySelectionFactory.Context(
                mode: mode,
                checkedCurrencyIds: checkedCurrencyIds,
                onChanged: onChanged,
                service: service
            )
            
            await MainActor.run {
                let vc = self.factory.make(context: context)
                self.root?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
