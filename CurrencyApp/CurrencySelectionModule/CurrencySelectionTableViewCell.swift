//
//  CurrencySelectionTableViewCell.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 28.11.2024.
//

import UIKit

final class CurrencySelectionTableViewCell: UITableViewCell {
    
    static let id = "CurrencySelectionCell"
    
    struct Model {
        let code: String
        let description: String
        let isChecked: Bool
    }
   
    // MARK: - UI Element

    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        return label
    }()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        selectionStyle = .none
        tintColor = .systemBlue
        
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update UI Element

    func update(with model: Model) {
        codeLabel.text = "\(model.code) - \(model.description)"
        accessoryType = model.isChecked ? .checkmark : .none
    }
}

//MARK: - Setup UI Elements

private extension CurrencySelectionTableViewCell {
    
    func setupSubviews() {
        contentView.addSubview(codeLabel)
        setupConstraints()
    }

    func setupConstraints() {
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            codeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            codeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            codeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            codeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
