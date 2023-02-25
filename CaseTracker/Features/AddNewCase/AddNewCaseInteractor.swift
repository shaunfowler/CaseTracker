//
//  AddNewCaseInteractor.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation
import Combine

class AddNewCaseInteractor: Interactor<AddNewCaseFeatureViewAction>, ObservableObject {

    let repository: Repository
    let router: Router

    var error: Error? {
        didSet {
            objectWillChange.send()
        }
    }
    var loading: Bool = false {
        didSet {
            objectWillChange.send()
        }
    }

    init(repository: Repository, router: Router) {
        self.repository = repository
        self.router = router
    }
    
    override func handle(action: AddNewCaseFeatureViewAction) {
        switch action {
        case .closeTapped:
            router.route(to: .myCases)
        case .acknowledgeError:
            self.error = nil
        case .addCaseTapped(let receiptNumber):
            loading = true
            Task { [weak self] in
                guard let self else { return }
                let result = await self.repository.addCase(receiptNumber: receiptNumber)
                switch result {
                case .success(_):
                    router.route(to: .myCases)
                case .failure(let error):
                    self.error = error
                }
                self.loading = false
            }
        }
    }
}
