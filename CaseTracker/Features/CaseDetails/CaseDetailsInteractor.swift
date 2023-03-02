//
//  CaseDetailsInteractor.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation
import Combine

protocol CaseDetailsInteractorProtocol {
    func deleteCase()
}

class CaseDetailsInteractor: CaseDetailsInteractorProtocol {

    var presenter: CaseDetailsPresenterProtocol

    let caseStatus: CaseStatus
    let repository: Repository
    let router: Router

    init(presenter: CaseDetailsPresenterProtocol, repository: Repository, router: Router, caseStatus: CaseStatus) {
        self.presenter = presenter
        self.repository = repository
        self.router = router
        self.caseStatus = caseStatus
    }

    func deleteCase() {
        Task {
            _ = await repository.removeCase(receiptNumber: caseStatus.receiptNumber)
            DispatchQueue.main.async { [weak self] in
                self?.router.route(to: .myCases)
            }
        }
    }
}
