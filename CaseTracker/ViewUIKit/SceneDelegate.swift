//
//  SceneDelegate.swift
//  CaseTracker
//
//  Created by Fowler, Shaun on 2/20/22.
//

import Foundation
import UIKit

class SceneDelegate: UIResponder, UISceneDelegate {
    var window: UIWindow?
}

#if UIKIT
extension SceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("SceneDelegate - willConnectTo")

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        window?.rootViewController = UINavigationController(rootViewController: HomeViewController())
        window?.makeKeyAndVisible()
    }
}
#endif
