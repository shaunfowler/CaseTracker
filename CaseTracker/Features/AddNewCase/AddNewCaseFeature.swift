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
        let interactor = AddNewCaseInteractor(repository: repository, router: router)
        let presenter = AddNewCasePresenter(interactor: interactor)
        return AddNewCaseViewController(presenter: presenter)
    }()

    init(repository: Repository, router: Router) {
        self.repository = repository
        self.router = router
    }
}
