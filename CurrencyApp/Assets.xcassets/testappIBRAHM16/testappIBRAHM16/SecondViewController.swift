//
//  SecondViewController.swift
//  testappIBRAHM16
//
//  Created by Ibrahim Timurkaev on 17.08.2023.
//

import UIKit

class SecondViewController: UIViewController {
    
    private let textlabel1: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Make your dreams"
        text.numberOfLines = 2
        text.textColor = .white
        text.textAlignment = .center
        text.font = .italicSystemFont(ofSize: 30)
        return text
    }()
    
    private let textLabel2: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "come true"
        text.textColor = .white
        text.font = text.font.withSize(27)
        return text
    }()
    
    private let textLabel3: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "JUST DO IT"
        text.textColor = .systemRed
        text.font = .boldSystemFont(ofSize: 40)
        return text
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupTextLabel1()
        setupTextLabel2()
        setupTextLabel3()
    }
    
    private func setupTextLabel1() {
        view.addSubview(textlabel1)
        
        textlabel1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250).isActive = true
        textlabel1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textlabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        textlabel1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
    }
    
    private func setupTextLabel2() {
        view.addSubview(textLabel2)
        
        textLabel2.topAnchor.constraint(equalTo: textlabel1.bottomAnchor, constant: 40).isActive = true
        textLabel2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupTextLabel3() {
        view.addSubview(textLabel3)
        
        textLabel3.topAnchor.constraint(equalTo: textLabel2.bottomAnchor, constant: 50).isActive = true
        textLabel3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

}
