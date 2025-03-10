//
//  ErrorView.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 26.12.2024.
//

import UIKit

protocol ErrorViewDelegate: AnyObject {
    func retryButtonTapped()
}

final class ErrorView: UIView {
    
    weak var delegate: ErrorViewDelegate?
    
    // MARK: - UI Elements
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "man")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TRY AGAIN", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI Elements

private extension ErrorView {
    
    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
        setupErrorMessage()
    }
        
    func setupSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(retryButton)
    }
    
    func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 320),
            imageView.heightAnchor.constraint(equalToConstant: 320),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            retryButton.widthAnchor.constraint(equalToConstant: 200),
            retryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupErrorMessage() {
        let attributedText = NSMutableAttributedString()
        
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.black
        ]
        let boldText = NSAttributedString(string: "Something went wrong\n", attributes: boldAttributes)
        attributedText.append(boldText)
        
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.gray
        ]
        let regularText = NSAttributedString(string: "Please try again", attributes: regularAttributes)
        attributedText.append(regularText)
        
        titleLabel.attributedText = attributedText
    }
    
    @objc func retryTapped() {
        delegate?.retryButtonTapped()
    }
}
