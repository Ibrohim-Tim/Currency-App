//
//  SceneDelegate.swift
//  testappIBRAHM16
//
//  Created by Ibrahim Timurkaev on 14.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = FourthViewController()
        window?.makeKeyAndVisible()
    }
}

