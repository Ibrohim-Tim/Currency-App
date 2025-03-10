//
//  SceneDelegate.swift
//  CurrencyApp
//
//  Created by Ibrahim Timurkaev on 01.10.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let factory = CurrencyListFactory()
        let currencyList = factory.create()
        let nav = UINavigationController(rootViewController: currencyList)
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}

