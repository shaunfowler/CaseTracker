//
//  SceneDelegate.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/28/23.
//

import Foundation
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var dependencies = DependencyFactory()
    lazy var router = dependencies.getRouter()
    var window: UIWindow?
    let navigationController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = router.navigationController
        router.route(to: .myCases)
        window?.makeKeyAndVisible()
    }
}
