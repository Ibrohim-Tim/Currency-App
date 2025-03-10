//
//  CurrencyListViewController.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 26.11.2024.
//

import UIKit

@MainActor
protocol CurrencyListViewProtocol: AnyObject {
    func updateFromSection(
        code: String,
        description: String,
        flagImageName: String
    )
    func updateToSection(model: CurrencyListView.Model)
    func showError()
    func hideError()
    func showSkeleton()
    func hideSkeleton()
}


final class CurrencyListViewController: UIViewController {
    
    private lazy var currencyListView = CurrencyListView(presenter: presenter)
    private let presenter: CurrencyListPresenterProtocol
    
    // MARK: - Init

    init(presenter: CurrencyListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func loadView() {
        view = currencyListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = presenter.title
        presenter.viewDidLoad()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.currencyListView.showSkeleton()
        self.presenter.viewDidLoad() //  оставить или убрать??
    }
    
    // MARK: - Private methods

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(selectCurrencyTapped)
        )
    }
    
    @objc private func selectCurrencyTapped() {
        presenter.openCurrencySelection(mode: .multiple)
    }
}

//MARK: - CurrencyListViewProtocol

extension CurrencyListViewController: CurrencyListViewProtocol {
  
    func updateFromSection(
        code: String,
        description: String,
        flagImageName: String
    ) {
        currencyListView.update(
            code: code,
            description:description,
            flagImageName: flagImageName
        )
    }
    
    func updateToSection(model: CurrencyListView.Model) {
        currencyListView.update(model: model)
    }
    
    func showError() {
        currencyListView.showError()
    }
    
    func hideError() {
        currencyListView.hideError()
    }
    
    func showSkeleton() {
        currencyListView.showSkeleton()
    }
    
    func hideSkeleton() {
        currencyListView.hideSkeleton()
    }
}
