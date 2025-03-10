//
//  CurrencyListTableViewCell.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 26.11.2024.
//

import UIKit

final class CurrencyListTableViewCell: UITableViewCell {
    
    static let id = "CurrencyTableViewCell"
    
    struct Model {
        let code: String
        let description: String
        let flag: String
        let rate: Double //  // TODO: !!!!  тут должен бвыть string
        let exchangeRate: String
    }
    
    // MARK: - UI Elements
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    private lazy var exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        selectionStyle = .none
        tintColor = .systemRed
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI Elements
    
    func configure(with currency: CurrencyListTableViewCell.Model) {
        flagImageView.image = UIImage(named: currency.flag)
        ?? UIImage(systemName: "flag")
        
        codeLabel.text = currency.code
        descriptionLabel.text = currency.description
        rateLabel.text = String(format: "%.2f", currency.rate) // TODO: Это не правильно !!!
        exchangeRateLabel.text = currency.exchangeRate
    }
}

// MARK: - Setup UI Elements

private extension CurrencyListTableViewCell {
    
    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
        
    func setupSubviews() {
        contentView.addSubview(flagImageView)
        contentView.addSubview(codeLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(rateLabel)
        contentView.addSubview(exchangeRateLabel)
    }
    
    func setupConstraints() {
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        exchangeRateLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        exchangeRateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        exchangeRateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 42),
            flagImageView.heightAnchor.constraint(equalToConstant: 32),
            
            codeLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 8),
            codeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            codeLabel.trailingAnchor.constraint(lessThanOrEqualTo: rateLabel.leadingAnchor, constant: -8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: codeLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: exchangeRateLabel.leadingAnchor, constant: -8),
            
            rateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            rateLabel.centerYAnchor.constraint(equalTo: codeLabel.centerYAnchor),
            
            exchangeRateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            exchangeRateLabel.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: 4)
        ])
    }
}
