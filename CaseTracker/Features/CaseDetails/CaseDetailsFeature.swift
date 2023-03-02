//
//  CaseDetailsFeature.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation
import Combine
import UIKit

enum CaseDetailsFeatureViewAction {
    case deleteCaseTapped
}

struct CaseDetailsFeatureViewState {
    let caseStatus: CaseStatus
}

class CaseDetailsFeature {

    let router: Router
    let repository: Repository
    let caseStatus: CaseStatus

    public lazy var rootViewController: UIViewController = {
        let presenter = CaseDetailsPresenter()
        let interactor = CaseDetailsInteractor(presenter: presenter,repository: repository, router: router, caseStatus: caseStatus)
        let viewController = CaseDetailsViewController(interactor: interactor, caseStatus: caseStatus)
        presenter.view = viewController
        return viewController
    }()

    init(repository: Repository, router: Router, caseStatus: CaseStatus) {
        self.repository = repository
        self.caseStatus = caseStatus
        self.router = router
    }
}
