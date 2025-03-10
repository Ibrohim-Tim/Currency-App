//
//  FourthViewController.swift
//  testappIBRAHM16
//
//  Created by Ibrahim Timurkaev on 17.08.2023.
//

import UIKit

class FourthViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "MB")
        return image
    }()
    
    private let textLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Mercedes-Benz — торговая марка и одноимённая компания — производитель легковых автомобилей премиального класса, грузовых автомобилей, автобусов и других транспортных средств, входящая в состав немецкого концерна «Mercedes-Benz Group»."
        text.textColor = .darkGray
        text.numberOfLines = 15
        text.textAlignment = .left
        text.font = .systemFont(ofSize: 30)
        return text
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
        
        setupImageView()
        setupTextLabel()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func setupTextLabel() {
        view.addSubview(textLabel)
        
        textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
    }
}
