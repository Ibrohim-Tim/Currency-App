//
//  CurrencySelectionView.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 28.11.2024.
//

import UIKit

final class CurrencySelectionView: UIView {
    
    // MARK: - Typealiases & Models
    
    typealias Item = CurrencySelectionTableViewCell.Model
    
    struct Model {
        let items: [Item]
    }
    
    // MARK: - UI Elements
    
    private var model: Model?
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(
            CurrencySelectionTableViewCell.self,
            forCellReuseIdentifier: CurrencySelectionTableViewCell.id
        )
        view.separatorInset = .zero
        view.tableFooterView = UIView()
        view.backgroundColor = .systemBackground
        view.separatorStyle = .singleLine
        view.separatorColor = .lightGray
        view.rowHeight = 44
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
        
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    private let presenter: CurrencySelectionPresenterProtocol
    
    // MARK: - Init
    
    init(presenter: CurrencySelectionPresenterProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
        
    func update(model: Model) {
        self.model = model
        tableView.isHidden = false
        errorView.isHidden = true
        tableView.reloadData()
    }
    
    func showError() {
        errorView.isHidden = false
        bringSubviewToFront(errorView)
    }
}

//MARK: - UITableViewDataSource

extension CurrencySelectionView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model,
              let cell = tableView.dequeueReusableCell(withIdentifier: CurrencySelectionTableViewCell.id)
                as? CurrencySelectionTableViewCell else {
            return UITableViewCell()
        }
        
        let item = model.items[indexPath.row]
        
        let cellModel = CurrencySelectionTableViewCell.Model(
            code: item.code,
            description: item.description,
            isChecked: item.isChecked
        )
        
        cell.update(with: cellModel)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CurrencySelectionView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter.didSelectAtRow(index: indexPath.row)
    }
}

// MARK: - ErrorViewDelegate

extension CurrencySelectionView: ErrorViewDelegate {
    func retryButtonTapped() {
        presenter.viewDidLoad()
    }
}

//MARK: - Setup UI Elements

private extension CurrencySelectionView {
    
    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
        
    func setupSubviews() {
        addSubview(tableView)
        addSubview(errorView)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            errorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            errorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
