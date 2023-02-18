//
//  AddNewCaseInteractor.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation
import Combine

class AddNewCaseInteractor: Interactor<AddNewCaseFeatureViewAction, AddNewCaseFeatureFeatureEvent>, ObservableObject {

    let repository: Repository

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

    init(eventSubject: PassthroughSubject<AddNewCaseFeatureFeatureEvent, Never>, repository: Repository) {
        self.repository = repository
        super.init(eventSubject: eventSubject)
    }
    
    override func handle(action: AddNewCaseFeatureViewAction) {
        switch action {
        case .closeTapped:
            eventSubject.send(.cancel)
        case .acknowledgeError:
            self.error = nil
        case .addCaseTapped(let receiptNumber):
            loading = true
            Task { [weak self] in
                guard let self else { return }
                let result = await self.repository.addCase(receiptNumber: receiptNumber)
                switch result {
                case .success(_):
                    self.eventSubject.send(.confirm(receiptNumber))
                case .failure(let error):
                    self.error = error
                }
                self.loading = false
            }
        }
    }
}
