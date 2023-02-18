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

    lazy var myCasesFeature = CasesFeatureFactory(dependencies: dependencies)
    lazy var addNewCaseFeature = AddNewCaseFeatureFeatureFactory(dependencies: dependencies)

    init(dependencies: DependencyFactory, navigationController: UINavigationController = .init()) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }

    func route(to route: Route) {
        switch route {
        case .myCases:
            Task {
//                await dependencies.getRepository().addCase(receiptNumber: "LIN2119051059")
//                await dependencies.getRepository().addCase(receiptNumber: "LIN2119051058")
//                await dependencies.getRepository().addCase(receiptNumber: "LIN2119051057")
//                await dependencies.getRepository().addCase(receiptNumber: "LIN2119151272")
            }
            navigationController.presentedViewController?.dismiss(animated: true)
            navigationController.viewControllers = [myCasesFeature.build()]
        case .addNewCase:
            navigationController.present(addNewCaseFeature.build(), animated: true)
        case .caseDetails:
            navigationController.present(UIViewController(), animated: true)
        }
    }
}
