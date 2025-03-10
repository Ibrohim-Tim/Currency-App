//
//  CurrencyListSkeletonCell.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 13.01.2025.
//

import UIKit

final class CurrencyListSkeletonCell: UIView {
    
    // MARK: - UI Elements
    
    private let flagSkeletonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let codeSkeletonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private let descriptionSkeletonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private let rateSkeletonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private let exchangeRateSkeletonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubview(flagSkeletonView)
        addSubview(codeSkeletonView)
        addSubview(descriptionSkeletonView)
        addSubview(rateSkeletonView)
        addSubview(exchangeRateSkeletonView)
    }
    
    private func setupConstraints() {
        flagSkeletonView.translatesAutoresizingMaskIntoConstraints = false
        codeSkeletonView.translatesAutoresizingMaskIntoConstraints = false
        descriptionSkeletonView.translatesAutoresizingMaskIntoConstraints = false
        rateSkeletonView.translatesAutoresizingMaskIntoConstraints = false
        exchangeRateSkeletonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            flagSkeletonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            flagSkeletonView.centerYAnchor.constraint(equalTo: centerYAnchor),
            flagSkeletonView.widthAnchor.constraint(equalToConstant: 42),
            flagSkeletonView.heightAnchor.constraint(equalToConstant: 32),
            
            codeSkeletonView.leadingAnchor.constraint(equalTo: flagSkeletonView.trailingAnchor, constant: 16),
            codeSkeletonView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            codeSkeletonView.widthAnchor.constraint(equalToConstant: 52),
            codeSkeletonView.heightAnchor.constraint(equalToConstant: 16),
            
            descriptionSkeletonView.leadingAnchor.constraint(equalTo: flagSkeletonView.trailingAnchor, constant: 16),
            descriptionSkeletonView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10),
            descriptionSkeletonView.widthAnchor.constraint(equalToConstant: 120),
            descriptionSkeletonView.heightAnchor.constraint(equalToConstant: 12),
            
            rateSkeletonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            rateSkeletonView.centerYAnchor.constraint(equalTo: codeSkeletonView.centerYAnchor),
            rateSkeletonView.widthAnchor.constraint(equalToConstant: 44),
            rateSkeletonView.heightAnchor.constraint(equalToConstant: 16),
            
            exchangeRateSkeletonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            exchangeRateSkeletonView.topAnchor.constraint(equalTo: rateSkeletonView.bottomAnchor, constant: 4),
            exchangeRateSkeletonView.widthAnchor.constraint(equalToConstant: 140),
            exchangeRateSkeletonView.heightAnchor.constraint(equalToConstant: 12),
        ])
    }
    
    // MARK: - Shimmer Animation
    
    func startShimmering() {
        let light = UIColor.white.withAlphaComponent(0.6).cgColor
        let dark = UIColor.lightGray.cgColor
        
        let gradient = CAGradientLayer()
        gradient.colors = [dark, light, dark]
        gradient.frame = bounds
        gradient.startPoint = CGPoint(x: -0.2, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.2, y: 0.5)
        gradient.locations = [0.0, 0.5, 1.0]
        
        layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.25]
        animation.toValue = [0.75, 1.0, 1.0]
        animation.duration = 1.6
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "shimmer")
    }
    
    func stopShimmering() {
        layer.mask = nil
    }
}
