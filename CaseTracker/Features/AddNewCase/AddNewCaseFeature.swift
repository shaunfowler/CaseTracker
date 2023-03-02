//
//  AddNewCaseFeature.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation
import Combine
import UIKit

enum AddNewCaseFeatureViewAction {
    case addCaseTapped(String)
    case closeTapped
    case acknowledgeError
}

struct AddNewCaseFeatureViewState {
    var error: Error?
    var loading: Bool
}

class AddNewCaseFeature {

    let router: Router
    let repository: Repository

    public lazy var rootViewController: UIViewController = {
        let presenter = AddNewCasePresenter()
        let interactor = AddNewCaseInteractor(presenter: presenter, repository: repository, router: router)
        let viewController = AddNewCaseViewController(interactor: interactor)
        presenter.view = viewController
        return viewController
    }()

    init(repository: Repository, router: Router) {
        self.repository = repository
        self.router = router
    }
}
