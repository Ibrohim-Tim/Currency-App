//
//  CurrencyListPresenter.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 26.11.2024.
//

import Foundation

protocol CurrencyListPresenterProtocol {
    var title: String { get }
    
    func openCurrencySelection(mode: CurrencySelectionFactory.Context.Mode)
    func updateAmount(_ amount: Double)
    func viewDidLoad()
    func handleInputChange(_ input: String)
    func containerTapped()
    func retryButtonTapped()
}

final class CurrencyListPresenter: CurrencyListPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: CurrencyListViewProtocol?
    
    private let dataManager: CurrencyDataManagerProtocol
    private let modelBuilder: CurrencyModelBuilder
    private let router: CurrencyListRouterProtocol
    private var userSettings: UserSettingsProtocol
    
    var title: String { "Currencies" }
    
    // MARK: - Initialization
    
    init(
        router: CurrencyListRouterProtocol,
        userSettings: UserSettingsProtocol,
        dataManager: CurrencyDataManagerProtocol,
        currencyFormatter: CurrencyFormatter = DefaultCurrencyFormatter()
    ) {
        self.router = router
        self.userSettings = userSettings
        self.dataManager = dataManager
        self.modelBuilder = CurrencyModelBuilder(
            currencyFormatter: currencyFormatter,
            userSettings: userSettings
        )
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        loadData()
    }
    
    func openCurrencySelection(mode: CurrencySelectionFactory.Context.Mode) {
        let checkedCurrencyIds = mode == .single
        ? [userSettings.currentCurrencyId]
        : Set(userSettings.currenciesIds)
        
        router.openCurrencySelection(
            mode: mode,
            checkedCurrencyIds: checkedCurrencyIds,
            service: dataManager.symbolsRepository
        ) { [weak self] updatedCurrencyIds in
            self?.handleCurrencySelectionUpdate(mode: mode, updatedCurrencyIds: updatedCurrencyIds)
        }
    }
    
    func handleInputChange(_ input: String) {
        guard let amount = Double(input) else { return }
        updateAmount(amount)
    }
    
    func updateAmount(_ amount: Double) {
        userSettings.currentAmount = amount
        dataManager.resetCache()
        convertAmountLocally(amount: amount)
    }
    
    func containerTapped() {
        openCurrencySelection(mode: .single)
    }
    
    func retryButtonTapped() {
        loadData()
    }
    
    // MARK: - Private Methods
    
    private func loadData() {
        Task { [weak self] in
            guard let self else { return }
            
            await view?.showSkeleton()
            await view?.hideError()
            
            do {
                let (symbols, rates) = try await dataManager.fetchAllData()
                updateFromSection(symbols: symbols)
                let model = modelBuilder.buildCurrencyListModel(from: symbols, rates: rates)
                await view?.updateToSection(model: model)
            } catch {
                await view?.showError()
            }
            
            await view?.hideSkeleton()
        }
    }
    
    private func handleCurrencySelectionUpdate(
        mode: CurrencySelectionFactory.Context.Mode,
        updatedCurrencyIds: Set<CurrencyId>
    ) {
        switch mode {
        case .single:
            if let currencyId = updatedCurrencyIds.first {
                userSettings.currentCurrencyId = currencyId
                dataManager.resetCache()
                updateFromSection(symbols: [CurrencyId: String]())
                loadData()
            }
        case .multiple:
            userSettings.currenciesIds = Array(updatedCurrencyIds)
            dataManager.resetCache()
            convertAmountLocally(amount: userSettings.currentAmount)
        }
    }
    
    private func updateToSection() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let (symbols, rates) = try await dataManager.fetchAllData()
                let model = modelBuilder.buildCurrencyListModel(from: symbols, rates: rates)
                await view?.updateToSection(model: model)
            } catch {
                await view?.showError()
            }
        }
    }
    
    private func updateFromSection(symbols: [CurrencyId: String]) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            do {
                let symbols = try await dataManager.fetchSymbols()
                guard let code = symbols[userSettings.currentCurrencyId] else { return }
                
                let flag = modelBuilder.getFlagImageName(for: userSettings.currentCurrencyId)
                
                view?.updateFromSection(
                    code: userSettings.currentCurrencyId,
                    description: code,
                    flagImageName: flag
                )
            } catch {
                view?.showError()
            }
        }
    }
    
    private func convertAmountLocally(amount: Double) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            do {
                async let symbolsTask = dataManager.fetchSymbols()
                async let ratesTask = dataManager.fetchRates()
                
                let symbols = try await symbolsTask
                let rates = try await ratesTask
                
                let items = rates.map { code, rate in
                    self.modelBuilder.buildCellModel(
                        code: code,
                        rate: rate,
                        symbols: symbols
                    )
                }
                
                let sortedItems = items.sorted { $0.code < $1.code }
                let model = CurrencyListView.Model(items: sortedItems)
                
                view?.updateToSection(model: model)
            } catch {
                view?.showError()
            }
        }
    }
}
