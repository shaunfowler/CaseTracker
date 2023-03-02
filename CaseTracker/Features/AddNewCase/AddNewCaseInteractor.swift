//
//  AddNewCaseInteractor.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation
import Combine

protocol AddNewCaseInteractorProtocol {
    func close()
    func addCase(withReceiptNumber receiptNumber: String)
}

class AddNewCaseInteractor: AddNewCaseInteractorProtocol {

    private let presenter: AddNewCasePresenterProtocol
    private let repository: Repository
    private let router: Router

    init(presenter: AddNewCasePresenterProtocol, repository: Repository, router: Router) {
        self.presenter = presenter
        self.repository = repository
        self.router = router
    }

    func close() {
        router.route(to: .myCases)
    }

    func addCase(withReceiptNumber receiptNumber: String) {
        presenter.setLoading(true)
        Task { [weak self] in
            guard let self else { return }
            let result = await self.repository.addCase(receiptNumber: receiptNumber)
            switch result {
            case .success(_):
                router.route(to: .myCases)
            case .failure(let error):
                self.presenter.showError(error)
            }
            self.presenter.setLoading(false)
        }
    }
}
