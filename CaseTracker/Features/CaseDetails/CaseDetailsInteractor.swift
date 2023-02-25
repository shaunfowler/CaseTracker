//
//  CaseDetailsInteractor.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation
import Combine

class CaseDetailsInteractor: Interactor<CaseDetailsFeatureViewAction>, ObservableObject {

    let caseStatus: CaseStatus
    let repository: Repository
    let router: Router

    init(repository: Repository, router: Router, caseStatus: CaseStatus) {
        self.repository = repository
        self.router = router
        self.caseStatus = caseStatus
    }

    override func handle(action: CaseDetailsFeatureViewAction) {
        switch action {
        case .deleteCaseTapped:
            Task {
                _ = await repository.removeCase(receiptNumber: caseStatus.receiptNumber)
                DispatchQueue.main.async { [weak self] in
                    self?.router.route(to: .myCases)
                }
            }
        }
    }
}
