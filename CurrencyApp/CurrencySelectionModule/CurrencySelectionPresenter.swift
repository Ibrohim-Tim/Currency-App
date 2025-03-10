//
//  CurrencySelectionPresenter.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 26.11.2024.
//

import UIKit

protocol CurrencySelectionPresenterProtocol {
    var title: String { get }
    
    func didSelectAtRow(index: Int)
    func viewDidLoad()
}

final class CurrencySelectionPresenter: CurrencySelectionPresenterProtocol {
    
    weak var view: CurrencySelectionViewProtocol?
    
    private let mode: CurrencySelectionFactory.Context.Mode
    private let service: SymbolsRepositoryProtocol
    private var model: [CurrencySelectionModel]?
    private var checkedCurrencyIds: Set<CurrencyId>
    private let onChanged: (Set<CurrencyId>) -> Void
    
    // MARK: - UI Elements

    var title: String {
        switch mode {
        case .single:
            return "Choose Currency"
        case .multiple:
            return "Add Currencies"
        }
    }
    
    // MARK: - Init

    init(
        service: SymbolsRepositoryProtocol,
        mode: CurrencySelectionFactory.Context.Mode,
        checkedCurrencyIds: Set<CurrencyId>,
        onChanged: @escaping (Set<CurrencyId>) -> Void
    ) {
        self.service = service
        self.mode = mode
        self.checkedCurrencyIds = checkedCurrencyIds
        self.onChanged = onChanged
    }
    
    func didSelectAtRow(index: Int) {
        guard let model = model, model.indices.contains(index) else { return }
        let currencyModel = model[index]
   
        switch mode {
        case .single:
            checkedCurrencyIds = [currencyModel.id]
        case .multiple:
            if checkedCurrencyIds.contains(currencyModel.id) {
                checkedCurrencyIds.remove(currencyModel.id)
            } else {
                checkedCurrencyIds.insert(currencyModel.id)
            }
        }
        
        updateUI()
        onChanged(checkedCurrencyIds)
    }
    
    // MARK: - Lifecycle

    func viewDidLoad() {
        Task {
            let result = await service.fetchSymbols()
            processResponse(response: result)
        }
    }
}

//MARK: - Update UI

private extension CurrencySelectionPresenter {
    
    func processResponse(response: Result<SymbolsModel, ApiClientError>) {
        guard case let .success(symbols) = response else {
            Task { @MainActor in
                showError()
            }
            return
        }
        model = convertToCurrencyModels(symbols)
        updateUI()
    }
    
    func updateUI() {
        guard let model = model, model.count > 0 else {
            Task { @MainActor in
                showError()
            }
            return
        }
        
        let items: [CurrencySelectionTableViewCell.Model] = model.map {
            .init(
                code: $0.code,
                description: $0.description,
                isChecked: checkedCurrencyIds.contains($0.id))
        }
        
        let viewModel: CurrencySelectionView.Model = .init(items: items)
        Task { @MainActor in
            updateView(with: viewModel)
        }
    }
    
    func convertToCurrencyModels(_ symbolsModel: SymbolsModel) -> [CurrencySelectionModel] {
        return symbolsModel.symbols.map { key, value in
            CurrencySelectionModel(
                id: key,
                code: key,
                description: value
            )
        }.sorted { $0.code < $1.code }
    }
    
    @MainActor
    func showError() {
        view?.showError()
    }
    
    @MainActor
    func updateView(with model: CurrencySelectionView.Model) {
        view?.update(model: model)
    }
}
