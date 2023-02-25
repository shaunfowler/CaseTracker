//
//  MyCasesInteractor.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-12.
//

import Foundation
import Combine

class CasesInteractor: Interactor<CasesViewAction>, ObservableObject {

    let repository: Repository
    let router: Router

    var casesPublisher: [CaseStatus]? = nil {
        didSet {
            objectWillChange.send()
        }
    }

    init(repository: Repository, router: Router) {
        self.repository = repository
        self.router = router
        super.init()
        bind()
    }

    private func bind() {
        repository
            .data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cases in
                guard let self else { return }
                self.casesPublisher = cases
            }
            .store(in: &cancellables)
    }

    override func handle(action: CasesViewAction) {
        switch action {
        case .viewDidLoad:
            Task {
                await repository.query(force: true)
            }
        case .caseSelected(let caseStatus):
            router.route(to: .caseDetails(caseStatus))
            print("TODO")
        case .addCaseTapped:
            router.route(to: .addNewCase)
            print("TODO")
        case .deleteCase(let caseId):
            Task {
                await repository.removeCase(receiptNumber: caseId)
            }
        }
    }
}
