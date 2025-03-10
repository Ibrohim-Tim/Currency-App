//
//  ThirdViewController.swift
//  testappIBRAHM16
//
//  Created by Ibrahim Timurkaev on 17.08.2023.
//

import UIKit

class ThirdViewController: UIViewController {
    
    private let imageView1: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "JUSTDOIT")
        return image
    }()
    
    private let imageView2: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "jdun")
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupImageView1()
        setupImageView2()
    }
    
    private func setupImageView1() {
        view.addSubview(imageView1)
        
        imageView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 130).isActive = true
        imageView1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView1.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView1.widthAnchor.constraint(equalToConstant: 315).isActive = true
    }
    
    private func setupImageView2() {
        view.addSubview(imageView2)
        
        imageView2.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: 90).isActive = true
        imageView2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView2.heightAnchor.constraint(equalToConstant: 230).isActive = true
        imageView2.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }

}
