//
//  SkeletonView.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 13.01.2025.
//

import UIKit

final class SkeletonView: UIView {
    
    // MARK: - Properties
    
    private var skeletonCells: [CurrencyListSkeletonCell] = []
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .white
        
        for i in 0..<5 {
            let skeletonCell = CurrencyListSkeletonCell()
            skeletonCell.translatesAutoresizingMaskIntoConstraints = false
            skeletonCell.tag = i == 0 ? 1 : 2
            addSubview(skeletonCell)
            skeletonCells.append(skeletonCell)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        var previousCell: UIView?
        
        for (index, cell) in skeletonCells.enumerated() {
            NSLayoutConstraint.activate([
                cell.leadingAnchor.constraint(equalTo: leadingAnchor),
                cell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                cell.heightAnchor.constraint(equalToConstant: 60)
            ])
            
            if let previous = previousCell {
                if index == 1 {
                    cell.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 32).isActive = true
                } else {
                    cell.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 8).isActive = true
                }
            } else {
                cell.topAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
            }
            
            previousCell = cell
        }
        
        if let lastCell = skeletonCells.last {
            lastCell.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16).isActive = true
        }
    }
    
    // MARK: - Shimmer Animation
    
    func startShimmering() {
        skeletonCells.forEach { $0.startShimmering() }
    }
    
    func stopShimmering() {
        skeletonCells.forEach { $0.stopShimmering() }
    }
}
