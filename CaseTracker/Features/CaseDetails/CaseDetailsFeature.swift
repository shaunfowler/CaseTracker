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
        let interactor = CaseDetailsInteractor(repository: repository, router: router, caseStatus: caseStatus)
        let presenter = CaseDetailsPresenter(interactor: interactor)
        return CaseDetailsViewController(presenter: presenter)
    }()

    init(repository: Repository, router: Router, caseStatus: CaseStatus) {
        self.repository = repository
        self.caseStatus = caseStatus
        self.router = router
    }
}
