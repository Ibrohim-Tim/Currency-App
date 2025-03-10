//
//  CurrencyListView.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 27.11.2024.
//

import UIKit

final class CurrencyListView: UIView {
    
    typealias Item = CurrencyListTableViewCell.Model
    
    struct Model {
        let items: [Item]
    }
    
    private var model: Model?
    
    // MARK: - UI Elements
    
    private var fromLabel: UILabel = {
        let label = UILabel()
        label.text = "From:"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private var fromFlagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private var codeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.isUserInteractionEnabled = true
        label.textColor = .white
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private var fromAmountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0.00"
        textField.font = .systemFont(ofSize: 18, weight: .regular)
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.clearsOnInsertion = false
        return textField
    }()
    
    private var toLabel: UILabel = {
        let label = UILabel()
        label.text = "To:"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.0, green: 0.4, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.register(
            CurrencyListTableViewCell.self,
            forCellReuseIdentifier: CurrencyListTableViewCell.id
        )
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private var lastUpdatedLabel: UILabel = {
        let label = UILabel()
        label.text = "Last updated: loading..."
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
        
    private var skeletonView: SkeletonView = {
        let skeleton = SkeletonView()
        skeleton.isHidden = true
        return skeleton
    }()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    private let presenter: CurrencyListPresenterProtocol
    
    // MARK: - Init
    
    init(presenter: CurrencyListPresenterProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func addDoneButtonToKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        fromAmountTextField.inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonTapped() {
        fromAmountTextField.resignFirstResponder()
    }
    
    @objc func containerTapped() {
        presenter.containerTapped()
    }
    
    func update(code: String, description: String, flagImageName: String) {
        codeLabel.text = code
        descriptionLabel.text = description
        fromFlagImageView.image = UIImage(named: flagImageName)
    }
    
    // MARK: - Update UI
    
    func update(model: Model) {
        self.model = model
        self.lastUpdatedLabel.text = "Last updated: \(DateFormatter.getCurrentDateString())"
        self.tableView.isHidden = false
        self.containerView.isHidden = false
        self.errorView.isHidden = true
        self.tableView.reloadData()
    }
    
    func showError() {
        self.errorView.isHidden = false
        self.containerView.isHidden = false
        self.tableView.isHidden = true
        self.bringSubviewToFront(self.errorView)
    }
    
    func hideError() {
        errorView.isHidden = true
    }
 
    func showSkeleton() {
        skeletonView.isHidden = false
        skeletonView.layer.mask = nil
        self.tableView.isHidden = true
        self.containerView.isHidden = true
        skeletonView.startShimmering()
    }
    
    func hideSkeleton() {
        skeletonView.isHidden = true
        skeletonView.stopShimmering()
        self.tableView.isHidden = false
        self.containerView.isHidden = false
    }
}

// MARK: - UITableViewDataSource

extension CurrencyListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CurrencyListTableViewCell.id,
            for: indexPath) as? CurrencyListTableViewCell,
              let item = model?.items[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UITextFieldDelegate

extension CurrencyListView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == fromAmountTextField {
            if let text = textField.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                presenter.handleInputChange(updatedText)
            }
        }
        return true
    }
}

// MARK: - ErrorViewDelegate

extension CurrencyListView: ErrorViewDelegate {
    func retryButtonTapped() {
        presenter.retryButtonTapped()
    }
}

// MARK: - Setup UI Elements

private extension CurrencyListView {
    
    func commonInit() {
        backgroundColor = .white
        setupSubviews()
        setupConstraints()
        addDoneButtonToKeyboard()
    }
    
    func setupSubviews() {
        addSubview(skeletonView)
        addSubview(fromLabel)
        addSubview(containerView)
        containerView.addSubview(fromFlagImageView)
        containerView.addSubview(codeLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(fromAmountTextField)
        addSubview(toLabel)
        addSubview(tableView)
        addSubview(errorView)
        addSubview(lastUpdatedLabel)
        
        tableView.dataSource = self
        fromAmountTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerTapped))
        containerView.addGestureRecognizer(tapGesture)
        
    }
    
    func setupConstraints() {
        skeletonView.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        fromFlagImageView.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        fromAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        lastUpdatedLabel.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            skeletonView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            skeletonView.leadingAnchor.constraint(equalTo: leadingAnchor),
            skeletonView.trailingAnchor.constraint(equalTo: trailingAnchor),
            skeletonView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            fromLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            fromLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            containerView.topAnchor.constraint(equalTo: fromLabel.bottomAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 56),
            
            fromFlagImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            fromFlagImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            fromFlagImageView.widthAnchor.constraint(equalToConstant: 42),
            fromFlagImageView.heightAnchor.constraint(equalToConstant: 32),
            
            codeLabel.topAnchor.constraint(equalTo: fromFlagImageView.topAnchor, constant: -4),
            codeLabel.leadingAnchor.constraint(equalTo: fromFlagImageView.trailingAnchor, constant: 8),
            
            descriptionLabel.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: codeLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: fromAmountTextField.leadingAnchor, constant: -8),
            
            fromAmountTextField.centerYAnchor.constraint(equalTo: fromFlagImageView.centerYAnchor),
            fromAmountTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            fromAmountTextField.widthAnchor.constraint(equalToConstant: 120),
            fromAmountTextField.heightAnchor.constraint(equalToConstant: 40),
            
            toLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 16),
            toLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: lastUpdatedLabel.topAnchor, constant: -8),
            
            lastUpdatedLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            lastUpdatedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            lastUpdatedLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            errorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            errorView.bottomAnchor.constraint(equalTo: lastUpdatedLabel.topAnchor, constant: -8),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
