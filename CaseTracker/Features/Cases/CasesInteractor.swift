//
//  MyCasesInteractor.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-12.
//

import Foundation
import Combine

protocol CasesInteracterProtocol {
    func loadCases()
    func caseSelected(_ case: CaseStatus)
    func addNewCase()
    func deleteCase(receiptNumber: String)
}

class CasesInteractor {

    private var cancellables = Set<AnyCancellable>()
    let repository: Repository
    let router: Router
    private var presenter: CasesPresenterProtocol

    init(presenter: CasesPresenterProtocol, repository: Repository, router: Router) {
        self.presenter = presenter
        self.repository = repository
        self.router = router
        bind()
    }

    private func bind() {
        repository
            .data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cases in
                guard let self else { return }
                // self.casesPublisher = cases
                // to presenter
                self.presenter.onCaseListUpdated(cases)

            }
            .store(in: &cancellables)
    }
}

extension CasesInteractor: CasesInteracterProtocol {
    func loadCases() {
        Task {
            await repository.query(force: true)
        }
    }

    func caseSelected(_ case: CaseStatus) {
        router.route(to: .caseDetails(`case`))

    }

    func addNewCase() {
        router.route(to: .addNewCase)

    }

    func deleteCase(receiptNumber: String) {
        Task {
            await repository.removeCase(receiptNumber: receiptNumber)
        }
    }
}
