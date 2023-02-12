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
}

class FeatureRouter {

    var sub: AnyCancellable?
    let dependencies: DependencyFactory
    let navigationController = UINavigationController()

    lazy var myCasesFeature = CasesFeatureFactory(dependencies: dependencies)

    init(dependencies: DependencyFactory) {
        self.dependencies = dependencies
    }

    func route(to route: Route) {
        switch route {
        case .myCases:
            // Task { await dependencies.getRepository().addCase(receiptNumber: "LIN2119051059") } // test
            navigationController.pushViewController(myCasesFeature.build(), animated: true)
        }
    }
}
