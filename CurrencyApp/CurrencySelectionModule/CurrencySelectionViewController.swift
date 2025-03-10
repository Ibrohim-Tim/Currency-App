//
//  CurrencySelectionViewController.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 26.11.2024.
//

import UIKit

protocol CurrencySelectionViewProtocol: AnyObject {
    func update(model: CurrencySelectionView.Model)
    func showError()
}

final class CurrencySelectionViewController: UIViewController {
        
    private lazy var customView = CurrencySelectionView(presenter: presenter)
    private let presenter: CurrencySelectionPresenterProtocol

    // MARK: - Init

    init(presenter: CurrencySelectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        title = presenter.title
        navigationController?.navigationBar.prefersLargeTitles = true
        presenter.viewDidLoad()
    }
}

//MARK: - CurrencySelectionViewProtocol

extension CurrencySelectionViewController: CurrencySelectionViewProtocol {
        
    func update(model: CurrencySelectionView.Model) {
        customView.update(model: model)
    }
    
    func showError() {
        customView.showError()
    }
}
