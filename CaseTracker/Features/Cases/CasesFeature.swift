//
//  MyCasesFeature.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-11.
//

import Foundation
import Combine
import UIKit

enum CasesViewAction {
    case viewDidLoad
    case addCaseTapped
    case caseSelected(CaseStatus)
    case deleteCase(String)
}

struct CasesViewState {
    var cases: [CaseStatus]
}

class CasesFeature {

    let router: Router
    let repository: Repository

    public lazy var rootViewController: UIViewController = {
        let presenter = CasesPresenter()
        let interactor = CasesInteractor(presenter: presenter, repository: repository, router: router)
        let viewController = CasesViewController(interactor: interactor)
        presenter.view = viewController
        return viewController
    }()

    init(repository: Repository, router: Router) {
        self.repository = repository
        self.router = router
    }
}
