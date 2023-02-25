//
//  FeatureRouter.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/28/23.
//

import Foundation
import UIKit
import Combine

enum Route {
    case myCases
    case addNewCase
    case caseDetails(CaseStatus)
}

protocol Router {
    var navigationController: UINavigationController { get }
    func route(to route: Route)
}

class FeatureRouter: Router {

    var sub: AnyCancellable?
    let dependencies: DependencyFactory
    var navigationController: UINavigationController

    init(dependencies: DependencyFactory, navigationController: UINavigationController = .init()) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }

    func route(to route: Route) {
        DispatchQueue.main.async { [weak navigationController, weak dependencies] in
            guard let navigationController, let dependencies else { return }
            switch route {
            case .myCases:
                navigationController.presentedViewController?.dismiss(animated: true)
                if navigationController.viewControllers.contains(where: { $0 is CasesViewController }) {
                    navigationController.popToRootViewController(animated: true)
                } else {
                    let feature = CasesFeature(repository: dependencies.getRepository(), router: self)
                    navigationController.viewControllers = [feature.rootViewController]
                }
            case .addNewCase:
                let feature = AddNewCaseFeature(repository: dependencies.getRepository(), router: self)
                navigationController.present(feature.rootViewController, animated: true)
            case .caseDetails(let caseStatus):
                let feature = CaseDetailsFeature(repository: dependencies.getRepository(), router: self, caseStatus: caseStatus)
                navigationController.pushViewController(feature.rootViewController, animated: true)
            }
        }

    }
}
