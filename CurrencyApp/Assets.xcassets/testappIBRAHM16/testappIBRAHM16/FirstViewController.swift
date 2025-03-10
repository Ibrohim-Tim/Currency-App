//
//  MainViewController.swift
//  testappIBRAHM16
//
//  Created by Ibrahim Timurkaev on 14.08.2023.
//

import UIKit

class FirstViewController: UIViewController {
    
    private let squircleView1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 60
        return view
    }()
    
    private let squircleLabel1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is black squircle"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = label.font.withSize(20)
        return label
    }()
    
    private let squareView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .purple
        return view
    }()
    
    private let squareLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is purple square"
        label.textAlignment = .left
        label.textColor = .purple
        label.numberOfLines = 2
        label.font = label.font.withSize(20)
        return label
    }()
    
//    private let triangleView3: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.frame = CGRect(x: 125, y: 650, width: 130, height: 20)
//        view.backgroundColor = .orange
//        return view
//    }()
    
    private let triangleLabel3: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is orange triangle"
        label.textColor = .orange
        label.numberOfLines = 2
        label.font = label.font.withSize(20)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let triangleView = TriangleView(frame: CGRect(x: 225, y: 620, width: 150, height: 150))
        triangleView.backgroundColor = .white
        view.addSubview(triangleView)
        
        setupSquircleView1()
        setupSquircleLabel1()
        setupSquareView2()
        setupSquareLabel2()
//        setupTriangleView3()
        setupTriangleLabel3()
    }
    
    private func setupSquircleView1() {
        view.addSubview(squircleView1)
        
        squircleView1.heightAnchor.constraint(equalToConstant: 120).isActive = true
        squircleView1.widthAnchor.constraint(equalToConstant: 120).isActive = true
        squircleView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        squircleView1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupSquircleLabel1() {
        view.addSubview(squircleLabel1)
        
        squircleLabel1.topAnchor.constraint(equalTo: squircleView1.bottomAnchor, constant: 10).isActive = true
        //squircleLabel1.centerXAnchor.constraint(equalTo: squircleView1.centerXAnchor).isActive = true
        squircleLabel1.leadingAnchor.constraint(equalTo: squircleView1.leadingAnchor).isActive = true
        squircleLabel1.trailingAnchor.constraint(equalTo: squircleView1.trailingAnchor).isActive = true
    }
    
    private func setupSquareView2() {
        view.addSubview(squareView2)
        
        squareView2.heightAnchor.constraint(equalToConstant: 150).isActive = true
        squareView2.widthAnchor.constraint(equalToConstant: 150).isActive = true
        squareView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        squareView2.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupSquareLabel2() {
        view.addSubview(squareLabel2)
        
        squareLabel2.leadingAnchor.constraint(equalTo: squareView2.trailingAnchor, constant: 10).isActive = true
        squareLabel2.centerYAnchor.constraint(equalTo: squareView2.centerYAnchor).isActive = true
    }
    
//    private func setupTriangleView3() {
//        view.addSubview(triangleView3)
//
//        triangleView3.heightAnchor.constraint(equalToConstant: 130).isActive = true
//        triangleView3.widthAnchor.constraint(equalToConstant: 130).isActive = true
//        triangleView3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
//        triangleView3.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
//    }
    
    private func setupTriangleLabel3() {
        view.addSubview(triangleLabel3)
        
        triangleLabel3.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 225).isActive = true
        triangleLabel3.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -140).isActive = true
    }
}

class TriangleView: UIView {

    override func draw(_ rect: CGRect) {
        guard let triangle = UIGraphicsGetCurrentContext() else { return }

        triangle.beginPath()
        triangle.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        triangle.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        triangle.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        triangle.closePath()

        triangle.setFillColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.85)
        triangle.fillPath()
    }
}
